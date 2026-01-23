#-------------Backend-----------------

output "s3_bucket_name" {
  value       = module.s3_backend.s3_bucket_name
  description = "Name of the S3 bucket for Terraform state"
}

output "dynamodb_table_name" {
  value       = module.s3_backend.dynamodb_table_name
  description = "Name of the DynamoDB table for state locking"
}

#-------------VPC-----------------

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

output "internet_gateway_ids" {
  value       = module.vpc.internet_gateway_ids
  description = "IDs of the Internet Gateway"
}

#-------------EKS-----------------

output "eks_cluster_endpoint" {
  value       = module.eks.eks_cluster_endpoint
  description = "EKS API endpoint for connecting to the cluster"
}

output "eks_cluster_name" {
  value       = module.eks.eks_cluster_name
  description = "Name of the EKS cluster"
}

output "eks_node_role_arn" {
  value       = module.eks.eks_node_role_arn
  description = "IAM role ARN for EKS Worker Nodes"
}

#-------------ECR-----------------

output "ecr_repository_url" {
  value       = module.ecr.ecr_repository_url
  description = "URL of the ECR repository"
}

#-------------JENKINS-----------------

output "jenkins_release" {
  value = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  value = module.jenkins.jenkins_namespace
}
