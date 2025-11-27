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
    ssh_authorized_keys = optional(list(string), [])
  }))
}


variable "rke2_server_ip" {
  description = "RKE2 server IP address"
  type        = string
}
