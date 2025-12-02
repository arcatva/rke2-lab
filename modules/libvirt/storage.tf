resource "libvirt_pool" "pool" {
  name = "pool"
  target = {
    path = "/var/lib/libvirt/pool"
  }
  type = "dir"
}

resource "libvirt_volume" "volumes" {
  for_each = var.vm_configs
  name     = "${each.key}-disk.qcow2"
  pool     = "pool"
  format   = "qcow2"

  capacity = each.value.disk * 1024 * 1024 * 1024

  backing_store = {
    path   = libvirt_volume.ubuntu_base.path
    format = "qcow2"
  }
  depends_on = [libvirt_pool.pool, libvirt_volume.ubuntu_base]
}


resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-jammy-base.qcow2"
  pool   = "pool"
  format = "qcow2"

  create = {
    content = {
      # Ubuntu 22.04 LTS (Jammy Jellyfish) cloud image
      url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    }
  }
  depends_on = [libvirt_pool.pool]
}

resource "libvirt_volume" "cloudinit-volumes" {
  for_each = var.vm_configs
  name     = "${each.key}-cloudinit.iso"
  pool     = "pool"
  # Format will be auto-detected as "iso"

  create = {
    content = {
      url = libvirt_cloudinit_disk.cloudinit-disks[each.key].path
    }
  }
  depends_on = [libvirt_pool.pool, libvirt_cloudinit_disk.cloudinit-disks]
}


resource "libvirt_cloudinit_disk" "cloudinit-disks" {
  for_each = var.vm_configs
  name     = "${each.key}-cloudinit"
  user_data = templatefile("${path.module}/templates/user_data.yaml.tftpl", {
    password           = each.value.password
    role               = each.value.role
    rke2_server_ip     = var.rke2_server_ip
    rke2_cluster_token = random_password.rke2_cluster_token.result
    ssh_public_key     = file(var.ssh_config.ssh_public_key_path)
  })

  meta_data = templatefile("${path.module}/templates/meta_data.yaml.tftpl", {
    instance_id    = each.key
    local_hostname = each.key
  })

  network_config = templatefile("${path.module}/templates/network_config.yaml.tftpl", {
    ip      = each.value.ip 
    gateway = each.value.gateway
    dns_servers = each.value.dns_servers
  })
  depends_on = [libvirt_pool.pool]
}

resource "random_password" "rke2_cluster_token" {
  length  = 32
  special = false
}
