# IAM Role for the EKS Cluster
resource "aws_iam_role" "eks" {
  # Name of the IAM role for the EKS cluster
  name = "${var.cluster_name}-eks-cluster"

  # Trust policy allowing the EKS service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AmazonEKSClusterPolicy to the IAM role
resource "aws_iam_role_policy_attachment" "eks" {
  # Policy ARN providing necessary permissions for EKS clusters
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  # The IAM role the policy is being attached to
  role      = aws_iam_role.eks.name
}

# EKS Cluster creation
resource "aws_eks_cluster" "eks" {
  # Cluster name
  name      = var.cluster_name

  # ARN of the IAM role required for cluster management
  role_arn  = aws_iam_role.eks.arn
  
  # Networking configuration (VPC)
  vpc_config {
    endpoint_private_access = true    # Enables private access to the API server
    endpoint_public_access  = true    # Enables public access to the API server
    subnet_ids              = module.vpc.private_subnets # List of subnets where EKS will operate
  }

  # Access configuration for the EKS cluster
  access_config {
    authentication_mode                         = "API" # Authentication via API
    bootstrap_cluster_creator_admin_permissions = true  # Grants admin rights to the cluster creator
  }

  # Ensure IAM policy attachment is complete before cluster creation
  depends_on = [aws_iam_role_policy_attachment.eks]
}