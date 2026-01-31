output "argo_cd_server_service" {
  description = "Argo CD server service"
  value       = "argo-cd.${var.namespace}.svc.cluster.local"
}

output "admin_password" {
  description = "Initial admin password"
  value       = "Run: kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
}

output "argo_cd_url" {
  value       = helm_release.argo_cd.status.load_balancer[0].ingress[0].hostname
  description = "Public DNS name of Argo CD LoadBalancer"
}