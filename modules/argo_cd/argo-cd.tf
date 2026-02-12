resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  create_namespace = true
  timeout = 1200
  skip_crds  = false

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

# This installs "Application" manifests (the bridge to Django app)
resource "helm_release" "argo_apps" {
  name      = "argo-apps"
  namespace = var.namespace
  chart     = "${path.module}/charts"

  # Wait for the controller to be ready before creating apps
  depends_on = [helm_release.argo_cd]
}

data "kubernetes_service" "argo_cd_server" {
  metadata {
    name      = "argo-cd-server"
    namespace = var.namespace
  }
  depends_on = [helm_release.argo_cd]
}