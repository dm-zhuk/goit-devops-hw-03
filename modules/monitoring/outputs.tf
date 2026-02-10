output "prometheus_port_forward" {
  value       = "kubectl --namespace ${var.namespace} port-forward svc/kube-prometheus-stack-prometheus 9090"
  description = "Command to access Prometheus UI"
}

output "grafana_port_forward" {
  value       = "kubectl --namespace ${var.namespace} port-forward svc/kube-prometheus-stack-grafana 3000:80"
  description = "Command to access Grafana UI"
}

output "grafana_admin_password" {
  value       = "admin" # to be changed
  description = "Default Grafana admin password"
}