# IAM Role for EC2 Worker Nodes
resource "aws_iam_role" "eks_node" {
  # Name of the role for the nodes
  name = "${var.cluster_name}-node-role"

  # Trust policy allowing EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attachment of the AmazonEKSWorkerNodePolicy
"eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

# Attachment of the AmazonEKS_CNI_Policy for the VPC CNI plugin
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

# Attachment of the AmazonEC2ContainerRegistryReadOnly policy
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}

# EKS Node Group creation
resource "aws_eks_node_group" "general" {
  # Name of the EKS cluster
  cluster_name = aws_eks_cluster.eks.name
  
  # Name of the node group
  node_group_name = "general"
  
  # IAM role for the nodes
  node_role_arn = aws_iam_role.nodes.arn

  # Subnets where EC2 nodes will be located
  subnet_ids = module.vpc.private_subnets

  # Capacity type and instance types for the nodes
  capacity_type  = "ON_DEMAND"
  instance_types = [var.instance_type]

  # Scaling configuration
  scaling_config {
    desired_size = var.desired_size  # Desired number of nodes
    max_size     = var.max_size      # Maximum number of nodes
    min_size     = var.min_size      # Minimum number of nodes
  }

  # Ignore changes to desired_size to avoid conflicts with Auto Scaling
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

  # Node update configuration
  update_config {
    max_unavailable = 1  # Maximum number of nodes that can be unavailable during update
  }

  # Labels assigned to the nodes
  labels = {
    role = "general"
  }

  # Ensure IAM policies are attached before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly
  ]
