resource "kubectl_manifest" "default_pool" {
    depends_on = [ helm_release.metallb ]
    yaml_body = <<YAML
      apiVersion: metallb.io/v1beta1
      kind: IPAddressPool
      metadata:
        name: default-pool
        namespace: metallb-system
      spec:
        addresses:
        - ${var.metallb_ip_range}
      YAML
}

resource "kubectl_manifest" "l2_advertisement" {
    depends_on = [ kubectl_manifest.default_pool ]
    yaml_body = <<YAML
      apiVersion: metallb.io/v1beta1
      kind: L2Advertisement
      metadata:
        name: example
        namespace: metallb-system
      YAML
}

