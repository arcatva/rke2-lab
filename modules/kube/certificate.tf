resource "kubectl_manifest" "selfsigned_issuer" {
    depends_on = [ helm_release.cert_manager ]
    yaml_body = <<YAML
        apiVersion: cert-manager.io/v1
        kind: ClusterIssuer
        metadata:
            name: selfsigned-cluster-issuer
        spec:
            selfSigned: {}
        YAML
}

resource "kubectl_manifest" "rancher_certificate" {
    depends_on = [ kubectl_manifest.selfsigned_issuer ]
    yaml_body = <<YAML
        apiVersion: cert-manager.io/v1
        kind: Certificate
        metadata:
            name: rancher-cert
            namespace: istio-ingress  
        spec:
            secretName: rancher-tls-credential
            duration: 2160h # 90 days
            renewBefore: 360h # 15 days
            commonName: rancher.lab
            dnsNames:
                - rancher.lab
            issuerRef:
                name: selfsigned-cluster-issuer
                kind: ClusterIssuer
                group: cert-manager.io
        YAML
}