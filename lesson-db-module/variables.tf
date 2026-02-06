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
  description = "Common tags for all resources"
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
  description = "Engine for standard RDS"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version for standard RDS"
  type        = string
  default     = "17.2"
}

variable "engine_cluster" {
  description = "Engine for Aurora cluster"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_cluster" {
  description = "Engine version for Aurora cluster"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_rds" {
  type    = string
  default = "postgres17"
}

variable "parameter_group_family_aurora" {
  type    = string
  default = "aurora-postgresql15"
}

# Sizing & Scaling
variable "instance_class" {
  type    = string
  default = "db.t3.small"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "aurora_instance_count" {
  description = "Total number of instances (Writer + Readers)"
  type        = number
  default     = 2
}

variable "multi_az" {
  type    = bool
  default = false
}

# Database Credentials
variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

# Network & Security
variable "vpc_id" {
  type = string
}

variable "subnet_private_ids" {
  type = list(string)
}

variable "subnet_public_ids" {
  type    = list(string)
  default = []
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "parameters" {
  description = "Map of DB parameters for the parameter group"
  type        = map(string)
  default     = {}
}