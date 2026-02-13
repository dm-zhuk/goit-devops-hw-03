variable "project_name" {
  type        = string
  description = "The prefix used for naming all resources in this project"
}

variable "name" {
  type        = string
  description = "A secondary name identifier for specific resources"
}

variable "use_aurora" {
  type        = bool
  description = "Boolean to toggle between Aurora Cluster (true) and standard RDS Instance (false)"
}

variable "instance_class" {
  type        = string
  description = "The compute instance type (e.g., db.t3.micro)"
}

variable "engine" {
  type        = string
  description = "The database engine to use (e.g., postgres or aurora-postgresql)"
}

variable "engine_version" {
  type        = string
  description = "The specific engine version for the database"
}

variable "engine_cluster" {
  type        = string
  description = "The engine for the Aurora cluster, if applicable"
}

variable "engine_version_cluster" {
  type        = string
  description = "The engine version for the Aurora cluster, if applicable"
}

variable "db_name" {
  type        = string
  description = "The name of the initial database to create"
}

variable "username" {
  type        = string
  description = "Master username for the database"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Master password for the database"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the database will be deployed"
}

variable "subnet_private_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the DB Subnet Group"
}

variable "subnet_public_ids" {
  type        = list(string)
  description = "List of public subnet IDs (if needed for connectivity)"
}

variable "eks_node_sg_id" {
  type        = string
  description = "The Security Group ID of the EKS nodes to allow inbound access"
}

variable "db_port" {
  type        = number
  default     = 5432
  description = "The port the database listens on"
}

variable "multi_az" {
  type        = bool
  description = "Whether to deploy the database in multiple Availability Zones"
}

variable "backup_retention_period" {
  type        = number
  description = "How many days to keep database backups"
}

variable "parameters" {
  type        = map(string)
  description = "A map of custom parameters to apply to the parameter group"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources in this module"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "The allocated storage in gigabytes (Standard RDS only)"
}

variable "replica_count" {
  type        = number
  default     = 1
  description = "Number of Aurora replicas to create"
}