
# Terraform & Provider Requirements
terraform {
  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    helm       = { source = "hashicorp/helm", version = "~> 2.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.0" }
  }
  required_version = "~> 1.5"

  backend "s3" {} 
}

provider "aws" {
  region = "eu-west-1"
}

# Infrastructure Modules (The Foundation)

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_name           = "lesson-8-9-vpc"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "dmjuke-goit-tf-state-2026"
  table_name  = "terraform-locks"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-8-9-ecr"
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = "eks-cluster-demo"
  subnet_ids    = module.vpc.public_subnet_ids
  instance_type = "t3.small"
}

# Dynamic Providers (The Handshake)
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

# Application Modules (The Software)
module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  region       = "eu-west-1"

  # Critical: Don't try to install Jenkins until EKS is active
  depends_on = [module.eks]

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "argo_cd" {
  source     = "./modules/argo_cd"
  namespace  = "argocd"
  
  # Critical: Don't try to install Argo until EKS is active
  depends_on = [module.eks]
  
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}