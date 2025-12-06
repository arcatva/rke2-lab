resource "kubectl_manifest" "selfsigned_issuer" {
  depends_on = [helm_release.cert_manager]
  yaml_body  = <<YAML
        apiVersion: cert-manager.io/v1
        kind: ClusterIssuer
        metadata:
            name: selfsigned-cluster-issuer
        spec:
            selfSigned: {}
        YAML
}


resource "kubectl_manifest" "root_ca_certificate" {
  depends_on = [kubectl_manifest.selfsigned_issuer]
  yaml_body  = <<YAML
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
        name: root-ca-tls-credential
        namespace: cert-manager 
    spec:
        isCA: true
        commonName: "My Lab Root CA"
        secretName: root-ca-tls-credential
        privateKey:
            algorithm: ECDSA
            size: 256
        issuerRef:
            name: selfsigned-cluster-issuer
            kind: ClusterIssuer
            group: cert-manager.io
YAML
}

resource "kubectl_manifest" "root_ca_issuer" {
  depends_on = [kubectl_manifest.root_ca_certificate]
  yaml_body  = <<YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
        name: root-ca-issuer
    spec:
        ca:
            secretName: ${kubectl_manifest.root_ca_certificate.name}
YAML
}


resource "kubectl_manifest" "rancher_certificate" {

  depends_on = [kubectl_manifest.root_ca_issuer]
  yaml_body  = <<YAML
        apiVersion: cert-manager.io/v1
        kind: Certificate
        metadata:
            name: rancher-tls-credential
            namespace: istio-ingress  
        spec:
            secretName: rancher-tls-credential
            duration: 2160h # 90 days
            renewBefore: 360h # 15 days
            commonName: rancher.lab
            dnsNames:
                - rancher.lab
            issuerRef:
                name: ${kubectl_manifest.root_ca_issuer.name}
                kind: ClusterIssuer
                group: cert-manager.io
        YAML
}


resource "kubectl_manifest" "argocd_certificate" {
  depends_on = [kubectl_manifest.root_ca_issuer]
  yaml_body  = <<YAML
        apiVersion: cert-manager.io/v1
        kind: Certificate
        metadata:
            name: argocd-tls-credential
            namespace: istio-ingress  
        spec:
            secretName: argocd-tls-credential
            duration: 2160h # 90 days
            renewBefore: 360h # 15 days
            commonName: argocd.lab
            dnsNames:
                - argocd.lab
            issuerRef:
                name: ${kubectl_manifest.root_ca_issuer.name}
                kind: ClusterIssuer
                group: cert-manager.io
        YAML
}
