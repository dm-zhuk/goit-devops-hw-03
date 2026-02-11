resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "61.3.1"

  # Config for 't3.medium'
  values = [
    <<-EOT
    grafana:
      adminPassword: "${var.grafana_admin_password}"
      service:
        type: ClusterIP
    prometheus:
      prometheusSpec:
        resources:
          requests:
            memory: "400Mi"
            cpu: "200m"
    EOT
  ]
}