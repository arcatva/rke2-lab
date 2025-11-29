locals {
  raw_config = yamldecode(file("${path.module}/config.yaml"))

  ssh_config = {
    ssh_public_key_path  = local.raw_config.ssh_config.ssh_public_key_path
    ssh_private_key_path = local.raw_config.ssh_config.ssh_private_key_path
  }
  
  vm_configs = {
    for name, config in local.raw_config : name => config
    if name != "ssh_config"
  }

  # Extract the first server IP for RKE2 server configuration
  server_ips     = [for k, v in local.vm_configs : v.ip if v.role == "server"]
  rke2_server_ip = length(local.server_ips) > 0 ? local.server_ips[0] : ""
}

module "vm_cluster" {
  source          = "../../modules/libvirt"
  vm_configs      = local.vm_configs
  rke2_server_ip  = local.rke2_server_ip
  ssh_config      = local.ssh_config
}

module "kube" {
  source       = "../../modules/kube"
  kubeconfig_path = module.vm_cluster.kubeconfig_path
}