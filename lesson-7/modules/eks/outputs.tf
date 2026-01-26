# Endpoint of the EKS control plane (for kubectl)
output "cluster_endpoint" {
  description = "EKS cluster API server endpoint URL"
  value       = aws_eks_cluster.cluster.endpoint
}

# Certificate authority data (base64) for kubeconfig
output "cluster_certificate_authority_data" {
  description = "Base64-encoded CA certificate for cluster authentication"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

# Cluster name (for aws eks commands)
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

# Node group name (for scaling/debugging)
output "node_group_name" {
  description = "Name of the managed node group"
  value       = aws_eks_node_group.general.node_group_name
}

# Node IAM role ARN (optional, for IRSA or debugging)
output "node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  value       = aws_iam_role.eks_node.arn
}