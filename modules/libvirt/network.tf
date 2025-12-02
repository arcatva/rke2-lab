resource "libvirt_network" "rke2_network" {

  name = "rke2_network"
  mode = var.network_configs.mode
  ips = {
    address = var.network_address
    netmask = var.network_netmask
  }
  autostart = true
  bridge    = (var.network_configs.mode == "bridge") ? var.network_configs.bridge : null
}
