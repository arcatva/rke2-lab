resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    name = "istio-ingress"
  }
}

resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
}

resource "kubernetes_namespace" "cattle_system" {
  # Rancher namespace
  metadata {
    name = "cattle-system"
  } 
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  } 
}