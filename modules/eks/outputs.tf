output "eks_cluster_endpoint" {
  description = "The endpoint for EKS Kubernetes API."
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_certificate_authority" {
  description = "The base64 encoded certificate data required to communicate with the cluster."
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_cluster_auth_token" {
  description = "The authentication token to authenticate with the hardware cluster."
  value       = data.aws_eks_cluster_auth.cluster.token
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.eks.name
}

output "node_security_group_id" {
  value = aws_security_group.node_sg.id
}

output "node_role_arn" {
  description = "The ARN of the IAM role assigned to EKS nodes"
  value       = aws_iam_role.nodes.arn
}