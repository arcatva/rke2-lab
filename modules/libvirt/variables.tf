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
