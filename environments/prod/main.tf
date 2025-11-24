locals {
  vm_configs = yamldecode(file("${path.module}/config.yaml"))

  # Load SSH keys from the user's home directory
  ssh_public_key  = file("~/.ssh/id_rsa.pub")
  ssh_private_key = file("~/.ssh/id_rsa")

  # Extract the first server IP for RKE2 server configuration
  server_ips     = [for k, v in local.vm_configs : v.ip if v.role == "server"]
  rke2_server_ip = length(local.server_ips) > 0 ? local.server_ips[0] : ""
}

module "vm_cluster" {
  source          = "../../modules/libvirt"
  vm_configs      = local.vm_configs
  rke2_server_ip  = local.rke2_server_ip
  ssh_public_key  = local.ssh_public_key
  ssh_private_key = local.ssh_private_key
}
