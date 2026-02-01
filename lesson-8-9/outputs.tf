# --- Backend (S3 + DynamoDB) ---
output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = module.s3_backend.dynamodb_table_name
}

# --- VPC ---
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

# --- EKS Cluster ---
output "eks_cluster_name" {
  description = "The name of the cluster created"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API endpoint (Use this for kubectl config)"
  value       = module.eks.eks_cluster_endpoint
}

# --- ECR (Crucial for CI/CD) ---
output "ecr_repository_url" {
  description = "URL for your Jenkins pipeline to push Docker images"
  value       = module.ecr.ecr_repository_url
}

# --- Jenkins ---
output "jenkins_namespace" {
  description = "Namespace where Jenkins resides"
  value       = "jenkins"
}

# --- Argo CD ---
output "argocd_server_status" {
  description = "Verification note for Argo CD deployment"
  value       = "Argo CD is managed via Helm in module.argo_cd"
}

output "argocd_admin_password_cmd" {
  description = "Command to run in terminal to get your Argo password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}