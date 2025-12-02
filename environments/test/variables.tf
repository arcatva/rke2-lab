# Start of File: modules/libvirt/variables.tf

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
    subnet  = optional(string)
    prefix  = optional(number)
  })

  default = {
    mode    = "nat"
    bridge  = null
    subnet  = "192.168.122.0"
    prefix = 24
  }
}

# End of File: modules/libvirt/variables.tf

# Start of File: modules/kube/variables.tf

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = null
}

variable "metallb_ip_range" {
  description = "MetalLB IP pool range"
  type        = string
}

# End of File: modules/kube/variables.tf
