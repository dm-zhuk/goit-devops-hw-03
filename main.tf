# Terraform & Provider Requirements
terraform {
  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    helm       = { source = "hashicorp/helm", version = "~> 2.15.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.31.0" }
  }
  required_version = "~> 1.5"
}

terraform {
  backend "s3" {
    bucket         = "final-project-tf-state-27"
    key            = "dev/final-project/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    helm       = { source = "hashicorp/helm", version = "~> 2.15.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.31.0" }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(var.tags, {
    Project   = var.name
    ManagedBy = "Terraform"
  })
}

# --- Infrastructure Modules ---

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_name           = var.name
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.bucket_name
  table_name  = "terraform-locks"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = "${var.name}-cluster"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.subnet_private_ids
  instance_type = var.instance_type
  desired_size  = 8
  min_size      = 5
  max_size      = 10
}

module "rds" {
  source = "./modules/rds"

  project_name   = var.name
  name           = var.name
  use_aurora     = var.use_aurora
  instance_class = var.instance_class

  engine                 = var.engine
  engine_version         = var.engine_version
  engine_cluster         = var.engine_cluster
  engine_version_cluster = var.engine_version_cluster

  db_name  = var.db_name
  username = var.username
  password = var.password

  vpc_id             = module.vpc.vpc_id
  subnet_private_ids = module.vpc.subnet_private_ids
  subnet_public_ids  = module.vpc.public_subnet_ids
  eks_node_sg_id     = module.eks.node_security_group_id

  replica_count           = var.replica_count
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  parameters              = var.parameters
  tags                    = local.common_tags
}

# --- Dynamic Providers (The Handshake) ---

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# --- Application Modules ---

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  region       = var.aws_region

  depends_on = [module.eks]

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "argo_cd" {
  source    = "./modules/argo_cd"
  namespace = "argocd"

  depends_on = [module.eks]

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "monitoring" {
  source                 = "./modules/monitoring"
  project_name           = var.name
  namespace              = "monitoring"
  tags                   = local.common_tags
  grafana_admin_password = var.grafana_admin_password

  depends_on = [module.eks]

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  force = true
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = module.eks.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::829703038395:user/student-admin"
        username = "dm-zhuk"
        groups   = ["system:masters"]
      }
    ])
  }

  depends_on = [module.eks]
}