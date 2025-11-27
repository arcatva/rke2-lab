locals {
  vm_configs = yamldecode(file("${path.module}/config.yaml"))

  # Extract the first server IP for RKE2 server configuration
  server_ips     = [for k, v in local.vm_configs : v.ip if v.role == "server"]
  rke2_server_ip = length(local.server_ips) > 0 ? local.server_ips[0] : ""
}

module "vm_cluster" {
  source          = "../../modules/libvirt"
  vm_configs      = local.vm_configs
  rke2_server_ip  = local.rke2_server_ip
}
