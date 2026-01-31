data "kubernetes_service" "argo_cd" {
  metadata {
    name      = "argo-cd-server"   # default service name from argo-cd chart
    namespace = "argocd"
  }

  depends_on = [helm_release.argo_cd]
}

output "argo_cd_url" {
  value       = "https://${data.kubernetes_service.argo_cd.status.0.load_balancer.0.ingress.0.hostname}"
  description = "Public URL to access Argo CD UI"
}

output "argo_cd_admin_password_command" {
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  description = "Run this command to get initial Argo CD admin password"
  sensitive   = true
}