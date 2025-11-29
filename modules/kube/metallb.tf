resource "kubectl_manifest" "default_pool" {

    depends_on = [ helm_release.metallb ]
    
    yaml_body = <<YAML
      apiVersion: metallb.io/v1beta1
      kind: IPAddressPool
      metadata:
        name: default-pool
        namespace: metalslb-system
      spec:
        addresses:
        - 192.168.0.240-192.168.0.250
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

