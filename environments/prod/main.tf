module "libvirt" {
  source         = "../../modules/libvirt"
  network_configs = var.network_configs
  vm_configs     = var.vm_configs
  ssh_config     = var.ssh_config
  rke2_server_ip = var.rke2_server_ip
}

module "kube" {
  source          = "../../modules/kube"
  metallb_ip_range = var.metallb_ip_range
  kubeconfig_path = module.libvirt.kubeconfig_path
}