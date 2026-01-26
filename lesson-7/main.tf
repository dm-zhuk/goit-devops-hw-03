terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.5"
}

provider "aws" {
  region = var.region # Connects to tfvars
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "dmjuke-goit-tf-state-lesson7-2026" 
  table_name  = "terraform-locks-lesson7"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  vpc_name           = "${var.cluster_name}-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-django-ecr"
  scan_on_push = true
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  instance_type   = var.instance_type
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
}