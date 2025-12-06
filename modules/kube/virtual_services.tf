resource "kubectl_manifest" "rancher_gateway" {
  depends_on = [helm_release.rancher, kubectl_manifest.rancher_certificate, helm_release.istio_ingress]
  yaml_body  = <<YAML
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
            credentialName: ${kubectl_manifest.rancher_certificate.name}
          hosts:
          - "rancher.lab"
      YAML
}

resource "kubectl_manifest" "rancher_virtual_service" {
  depends_on = [kubectl_manifest.rancher_gateway]
  yaml_body  = <<YAML
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
        - route:
          - destination:
              host: rancher.${kubernetes_namespace.cattle_system.metadata[0].name}.svc.cluster.local
              port:
                number: 80
      YAML
}



resource "kubectl_manifest" "argocd_gateway" {
  depends_on = [helm_release.argocd, kubectl_manifest.argocd_certificate, helm_release.istio_ingress]
  yaml_body  = <<YAML
      apiVersion: networking.istio.io/v1alpha3
      kind: Gateway
      metadata:
        name: argocd-gateway
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
            credentialName: ${kubectl_manifest.argocd_certificate.name}
          hosts:
          - "argocd.lab"
      YAML
}

resource "kubectl_manifest" "argocd_virtual_service" {
  depends_on = [kubectl_manifest.argocd_gateway]
  yaml_body  = <<YAML
      apiVersion: networking.istio.io/v1alpha3
      kind: VirtualService
      metadata:
        name: argocd
        namespace: ${kubernetes_namespace.argocd.metadata[0].name}
      spec:
        hosts:
        - "argocd.lab"
        gateways:
        - ${kubernetes_namespace.istio_ingress.metadata[0].name}/${kubectl_manifest.argocd_gateway.name}
        http:
        - route:
          - destination:
              host: argocd-server.${kubernetes_namespace.argocd.metadata[0].name}.svc.cluster.local
              port:
                number: 80
      YAML
}
