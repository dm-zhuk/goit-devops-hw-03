# Database Connection & App Config

output "db_hostname" {
  description = "The address of the database (Aurora Cluster or RDS Instance)"
  value       = module.rds.db_endpoint # Переконайтеся, що в модулі rds є такий output
}

output "db_port" {
  description = "The connection port"
  value       = module.rds.db_port
}

output "django_database_url" {
  description = "Formatted URL for Django .env file (Sensitive)"
  sensitive   = true
  value       = "postgres://${var.username}:${var.password}@${module.rds.db_endpoint}:${module.rds.db_port}/${var.db_name}"
}

# EKS Cluster Access

output "eks_cluster_name" {
  description = "The name of the EKS cluster for kubectl configuration"
  value       = module.eks.eks_cluster_name
}

output "eks_kubectl_config_command" {
  description = "Run this command to configure local kubectl to talk to the new cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.eks_cluster_name}"
}

# Infrastructure Audit & Security

output "rds_security_group_id" {
  description = "Security Group ID of the database for firewall verification"
  value       = module.rds.db_security_group_id
}

output "is_aurora_enabled" {
  description = "Logical check: True = Aurora Cluster, False = Standard RDS"
  value       = var.use_aurora
}

output "vpc_id" {
  description = "The ID of the VPC created for this project"
  value       = module.vpc.vpc_id
}

# GitOps & Jenkins Connectivity

output "jenkins_service_url" {
  description = "The internal Kubernetes DNS for Jenkins"
  value       = "jenkins.jenkins.svc.cluster.local"
}

output "jenkins_admin_password_command" {
  description = "Command to get Jenkins admin password"
  value       = "kubectl get secret --namespace jenkins jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode; echo"
}

output "argocd_url" {
  description = "Public URL for the ArgoCD Web UI"
  # Використовуємо try() про всяк випадок, якщо LB ще не створив hostname
  value = "https://${module.argo_cd.load_balancer_hostname}"
}

output "argocd_admin_password_command" {
  description = "Command to get the initial admin password for ArgoCD"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
}

# Monitoring (Grafana & Prometheus)

output "grafana_access" {
  description = "Access Grafana at http://localhost:3000"
  value       = "kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring"
}

output "grafana_password_command" {
  description = "Command to get Grafana admin password"
  value       = "kubectl get secret --namespace monitoring kube-prometheus-stack-grafana -o jsonpath='{.data.admin-password}' | base64 --decode; echo"
}