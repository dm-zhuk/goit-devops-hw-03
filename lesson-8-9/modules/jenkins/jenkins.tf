resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.0.16"
  create_namespace = true

  # Pulls custom config for Kaniko/Git agents
  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.servicePort"
    value = 80
  }

  set {
  name  = "controller.image.tag"
  value = "2.479.1"
}
}