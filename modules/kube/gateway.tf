resource "kubectl_manifest" "rancher_gateway" {
    depends_on = [ helm_release.rancher, kubectl_manifest.rancher_certificate ]
    yaml_body = <<YAML
      apiVersion: networking.istio.io/v1alpha3
      kind: Gateway
      metadata:
        name: rancher-gateway
        namespace: ${kubernetes_namespace.istio_ingress.metadata[0].name}
      spec:
        selector:
          istio: ingress
        servers:
        - port:
            number: 443
            name: https
            protocol: HTTPS
          tls:
            mode: SIMPLE
            credentialName: rancher-tls-credential
          hosts:
          - "rancher.lab"
      YAML
}

resource "kubectl_manifest" "rancher_virtual_service" {
    depends_on = [ kubectl_manifest.rancher_gateway ]
    yaml_body = <<YAML
      apiVersion: networking.istio.io/v1alpha3
      kind: VirtualService
      metadata:
        name: rancher
        namespace: ${kubernetes_namespace.cattle_system.metadata[0].name}
      spec:
        hosts:
        - "rancher.lab"
        gateways:
        - ${kubernetes_namespace.istio_ingress.metadata[0].name}/${kubectl_manifest.rancher_gateway.name}
        http:
        - match:
          - uri:
              prefix: /longhorn
          rewrite:
            uri: /
          route:
          - destination:
              # Assuming standard Longhorn service name and namespace. 
              # Adjust 'longhorn-frontend' and 'longhorn-system' if yours differ.
              host: longhorn-frontend.longhorn-system.svc.cluster.local
              port:
                number: 80
        - route:
          - destination:
              host: rancher.${kubernetes_namespace.cattle_system.metadata[0].name}.svc.cluster.local
              port:
                number: 80
      YAML
}   