data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "jenkins"
  }

  depends_on = [helm_release.jenkins]
}

output "jenkins_url" {
  value       = try("http://${data.kubernetes_service.jenkins.status.0.load_balancer.0.ingress.0.hostname}", "Pending... (wait for LoadBalancer)")
  description = "Public URL to access Jenkins dashboard"
}

output "jenkins_namespace" {
  value       = "jenkins"
  description = "Kubernetes namespace where Jenkins is deployed"
}