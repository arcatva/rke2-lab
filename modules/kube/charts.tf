resource "helm_release" "cert_manager" {
    name = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart      = "cert-manager"
    version    = "v1.19.1"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
    set = [
        {
        name  = "crds.enabled"
        value = "true"
        }
    ]
}

resource "helm_release" "istio" {
    name       = "istio"
    repository = "https://istio-release.storage.googleapis.com/charts"
    chart      = "base"
    version    = "1.28.0"
    namespace = kubernetes_namespace.istio_system.metadata[0].name
    set = [{
        name ="defaultRevision"
        value = "default"
    }]
}

resource "helm_release" "istiod" {
    name       = "istiod"
    repository = "https://istio-release.storage.googleapis.com/charts"
    chart      = "istiod"
    version    = "1.28.0"
    namespace = kubernetes_namespace.istio_system.metadata[0].name
  
}

resource "helm_release" "metallb" {
    name = "metallb"
    repository = "https://metallb.github.io/metallb"
    chart      = "metallb"
    version = "0.15.2"
    namespace = kubernetes_namespace.metallb_system.metadata[0].name
    timeout = 600
}

resource "helm_release" "istio_ingress" {
    name       = "istio-ingress"
    repository = "https://istio-release.storage.googleapis.com/charts"
    chart      = "gateway"
    version    = "1.28.0"
    namespace = kubernetes_namespace.istio_ingress.metadata[0].name
    depends_on = [ kubectl_manifest.default_pool]
}

resource "helm_release" "rancher" {
    name = "rancher"
    repository = "https://releases.rancher.com/server-charts/stable"
    chart      = "rancher"
    version    = "2.13.0"
    namespace = kubernetes_namespace.cattle_system.metadata[0].name
    set = [ 
        {
            name = "hostname"
            value = "rancher.lab"
        },
        {
            name = "ingress.enable"
            value = "false"
        },
        {
            name = "tls"
            value = "external"
        }
    ]
    depends_on = [ helm_release.istio_ingress ]
    timeout = 600
}


resource "helm_release" "longhorn" {
    name = "longhorn"
    repository = "https://charts.longhorn.io"
    chart      = "longhorn"
    version    = "1.10.1"
    namespace = kubernetes_namespace.longhorn_system.metadata[0].name
    set = [ 
        {
            name  = "persistence.defaultClassReplicaCount"
            value = "2"
        } 
    ]
    timeout = 600
}

resource "helm_release" "argocd" {
    name = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    version    = "9.1.6"
    namespace = kubernetes_namespace.argocd.metadata[0].name

    set = [ 
        {
            name = "global.domain"
            value = "argocd.lab"
        },
        {
            name  = "configs.params.server\\.insecure"
            value = "true"
        }

    ]
    timeout = 600
}