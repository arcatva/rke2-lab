variable "vm_configs" {
  description = "VM configurations with static IPs"
  type = map(object({
    memory              = number
    vcpu                = number
    ip                  = string
    gateway             = string
    disk                = number
    password            = string
    role                = string
    dns_servers        = list(string)
    network_type      = string
  }))
}

variable "ssh_config" {
  type = object({
    ssh_public_key_path = string
    ssh_private_key_path = string
  })
}

variable "rke2_server_ip" {
  description = "RKE2 server IP address"
  type        = string
}

variable "network_configs" {
  description = "Network configuration object"
  type = object({
    mode    = string
    bridge  = optional(string)
    subnet  = string
    netmask = string
  })

  default = {
    mode    = "nat"
    bridge  = null
    subnet  = "192.168.122.0"
    netmask = "255.255.255.0"
  }
}