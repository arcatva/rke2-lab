resource "libvirt_domain" "domains" {
  for_each = var.vm_configs

  name   = each.key
  memory = each.value.memory * 1024 * 1024
  vcpu   = each.value.vcpu

  os = {
    type        = "hvm"
    type_arch   = "x86_64"
    kernel_args = "net.ifnames=0 biosdevname=0 console=ttyS0 root=/dev/vda1"
    kernel      = "/boot/vmlinuz"
    initrd      = "/boot/initrd.img"
  }

  devices = {
    disks = [
      # Main system disk
      {
        source = {
          pool   = libvirt_volume.volumes[each.key].pool
          volume = libvirt_volume.volumes[each.key].name
        }
        target = {
          bus = "virtio"
          dev = "vda"
        }
      },
      # Cloud-init config disk (will be detected automatically)
      {
        device = "cdrom"
        source = {
          pool   = libvirt_volume.cloudinit-volumes[each.key].pool
          volume = libvirt_volume.cloudinit-volumes[each.key].name
        }
        target = {
          bus = "sata"
          dev = "sda"
        }
      }
    ]

    interfaces = [
      {
        type = libvirt_network.rke2_network.mode
        model = "virtio"

        source = {
            bridge = libvirt_network.rke2_network.mode == "bridge"? libvirt_network.rke2_network.bridge : null
            network = libvirt_network.rke2_network.mode == "network"? libvirt_network.rke2_network.name : null
        }
      }
    ]

    # Graphics console (VNC)
    graphics = {
      vnc = {
        autoport = "yes"
        listen   = "127.0.0.1"
      }
    }
  }

  # Start the VM automatically
  running = true

}

resource "null_resource" "kubeconfig" {
    provisioner "remote-exec" {
    inline = [
      <<-EOF
      #!/bin/bash
      cloud-init status --wait
      if [ ! -f /tmp/rke2.yaml ]; then
        echo "RKE2 config not found. This is a worker node."
        echo "Exiting gracefully."
        exit 0
      fi
      echo "RKE2 config found."
      EOF
    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.ssh_config.ssh_private_key_path)
      host = var.rke2_server_ip
    }
  }
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.ssh_config.ssh_private_key_path} ubuntu@${var.rke2_server_ip}:/tmp/rke2.yaml ./kubeconfig.yaml"
  }

  depends_on = [ libvirt_domain.domains ]
}

output "kubeconfig_path" {
  value = abspath("./kubeconfig.yaml")
  depends_on = [ null_resource.kubeconfig ]
}