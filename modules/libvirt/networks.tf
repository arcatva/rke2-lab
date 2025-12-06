resource "libvirt_network" "rke2_network" {
  name = "rke2_network"
  mode = var.network_configs.mode
  ips = (var.network_configs.mode == "bridge") ? null : [{
    address = var.network_configs.subnet
    prefix  = var.network_configs.prefix
  }] 
  autostart = true
  bridge    = (var.network_configs.mode == "bridge") ? var.network_configs.bridge : null
}
