variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "goit-devops-hw03"
}

# Cloud Provider Settings
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-west-1"
}

# Project Metadata
variable "name" {
  description = "The base name for all resources"
  type        = string
}

variable "tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

# Logic Toggles
variable "use_aurora" {
  description = "Set to true to use Aurora Cluster, false for standard RDS"
  type        = bool
}

# Database Engine & Versioning
variable "engine" {
  description = "Engine for standard RDS (e.g., postgres)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version for standard RDS"
  type        = string
  default     = "17.2"
}

variable "engine_cluster" {
  description = "Engine for Aurora cluster (e.g., aurora-postgresql)"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_cluster" {
  description = "Engine version for Aurora cluster"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_rds" {
  description = "Parameter group family for standard RDS"
  type        = string
  default     = "postgres17"
}

variable "parameter_group_family_aurora" {
  description = "Parameter group family for Aurora cluster"
  type        = string
  default     = "aurora-postgresql15"
}

# Sizing & Scaling
variable "instance_class" {
  description = "Instance type for the database"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Storage size in GB (ignored by Aurora)"
  type        = number
  default     = 20
}

variable "replica_count" {
  description = "Total number of Aurora instances"
  type        = number
  default     = 1
}

variable "multi_az" {
  description = "Enable High Availability across multiple AZs"
  type        = bool
  default     = false
}

# Database Credentials
variable "db_name" {
  description = "The name of the initial database"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
}

variable "password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

# Network & Security
variable "vpc_id" {
  description = "VPC ID where the database will reside"
  type        = string
}

variable "subnet_private_ids" {
  description = "List of private subnets for the database group"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "List of public subnets"
  type        = list(string)
  default     = []
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "parameters" {
  description = "Map of DB parameters for the custom parameter group"
  type        = map(string)
  default     = {}
}