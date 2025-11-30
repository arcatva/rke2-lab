variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type = string
  default = null
}

variable "metallb_ip_range" {
  description = "MetalLB IP pool range"
  type = string
}