# IAM Role for EC2 Worker Nodes
resource "aws_iam_role" "eks_node" {
  name = "${var.cluster_name}-node-role"

  # Trust policy allowing EC2 instances to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AmazonEKSWorkerNodePolicy (required for nodes to join cluster)
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

# Attach AmazonEKS_CNI_Policy (for VPC CNI networking)
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

# Attach AmazonEC2ContainerRegistryReadOnly (allows nodes to pull images from ECR)
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}

# EKS Managed Node Group
resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.cluster.name   # Reference to cluster from eks.tf
  node_group_name = "general"
  node_role_arn = aws_iam_role.eks_node.arn

  subnet_ids = var.subnet_ids                  # From module input (private subnets)

  capacity_type  = "ON_DEMAND"
  instance_types = [var.instance_type]         # e.g. "t3.medium" from variables

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # Prevent Terraform from fighting with cluster autoscaler
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1  # Safe rolling update
  }

  # Node labels (useful for scheduling)
  labels = {
    role = "general"
  }

  # Ensure policies are attached before node group creation
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly
  ]

  tags = {
    Name = "${var.cluster_name}-general-nodes"
  }
}