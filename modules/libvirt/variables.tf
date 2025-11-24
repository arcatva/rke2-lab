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
    ssh_private_key     = optional(string, "")
  }))
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
  default     = ""
}

variable "ssh_private_key" {
  description = "SSH private key content"
  type        = string
  default     = ""
}


variable "rke2_server_ip" {
  description = "RKE2 server IP address"
  type        = string
}
