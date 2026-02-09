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

# --- EBS CSI Driver Storage Fix ---
resource "aws_iam_role_policy_attachment" "node_ebs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "aws-ebs-csi-driver"

  # Ensures the permissions exist before the driver starts
  depends_on = [aws_iam_role_policy_attachment.node_ebs_policy]
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

# --- Data Sources for Providers ---
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks.name
}