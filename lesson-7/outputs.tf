output "s3_bucket_name" {
  value       = module.s3_backend.s3_bucket_name
  description = "Name of the S3 bucket for Terraform state"
}

output "dynamodb_table_name" {
  value       = module.s3_backend.dynamodb_table_name
  description = "Name of the DynamoDB table for state locking"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "IDs of the private subnets"
}

output "ecr_repository_url" {
  value       = module.ecr.ecr_repository_url
  description = "The full URL of the ECR repository (for docker push/pull)"
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API server endpoint URL"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64-encoded CA certificate for cluster authentication"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_node_group_name" {
  description = "Name of the EKS managed node group"
  value       = module.eks.node_group_name
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  value       = module.eks.node_role_arn
}