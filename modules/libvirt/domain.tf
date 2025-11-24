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

    # Network interface on default network (DHCP)
    interfaces = [
      {
        type  = "bridge"
        model = "virtio"
        source = {
          bridge = "virbr0"
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
