resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
  ]
  }
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    name = "istio-ingress"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
  ]
  }
}

resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
  ]
  }
}

resource "kubernetes_namespace" "cattle_system" {
  # Rancher namespace
  metadata {
    name = "cattle-system"
  } 
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
  ]
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  } 
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
  ]
  }
}

resource "kubernetes_namespace" "longhorn_system" {
  metadata {
    name = "longhorn-system"
  } 
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
  ]
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  } 
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
  ]
  }
}