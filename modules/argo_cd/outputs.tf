output "load_balancer_hostname" {
  description = "The DNS name of the ArgoCD LoadBalancer"
  value       = try(data.kubernetes_service.argo_cd_server.status[0].load_balancer[0].ingress[0].hostname, "pending...")
}

# Ваші команди для зручності
output "argo_cd_url_command" {
  description = "Run this command to get the Argo CD LoadBalancer URL"
  value       = "kubectl get svc -n ${var.namespace} argo-cd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "argo_cd_admin_password_command" {
  value       = "kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo"
  description = "Command to retrieve the initial admin password"
}