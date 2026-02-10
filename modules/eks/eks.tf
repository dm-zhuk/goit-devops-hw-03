# --- Cluster IAM Role ---
resource "aws_iam_role" "eks" {
  name = "${var.cluster_name}-eks-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

# --- EKS Cluster Definition ---
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}

# Data sources for internal module use
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks.name
}