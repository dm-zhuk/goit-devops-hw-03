# --- Database Connection & App Config ---

output "db_hostname" {
  description = "The address of the database (Aurora Cluster or RDS Instance)"
  value       = module.rds.db_endpoint
}

output "db_port" {
  description = "The connection port"
  value       = module.rds.db_port
}

output "django_database_url" {
  description = "Formatted URL for Django .env file (Sensitive)"
  sensitive   = true
  value       = format("postgres://%s:%s@%s:%s/%s", var.username, var.password, module.rds.db_endpoint, module.rds.db_port, var.db_name)
}

# --- EKS Cluster Access ---

output "eks_cluster_name" {
  description = "The name of the EKS cluster for kubectl configuration"
  value       = module.eks.eks_cluster_name
}

output "eks_kubectl_config_command" {
  description = "Run this command to configure local kubectl to talk to the new cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.eks_cluster_name}"
}

# --- Infrastructure Audit & Security ---

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

# --- GitOps & Jenkins Connectivity ---

output "jenkins_service_url" {
  description = "The internal Kubernetes DNS for Jenkins (if deployed)"
  value       = "jenkins.jenkins.svc.cluster.local"
}

output "argo_cd_login_command" {
  description = "Command to get Argo CD initial admin password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
}

# --- Prometheus & Grafana Accessibility ---

output "grafana_url" {
  description = "Command to access Grafana UI"
  value       = "kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring"
}

output "prometheus_url" {
  description = "Command to access Prometheus UI"
  value       = "kubectl port-forward svc/kube-prometheus-stack-prometheus 9090 -n monitoring"
}