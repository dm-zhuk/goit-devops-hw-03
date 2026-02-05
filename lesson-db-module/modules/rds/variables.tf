variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the DB will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets for the DB Subnet Group"
  type        = list(string)
}

variable "eks_node_sg_id" {
  description = "Security Group ID of the EKS nodes to allow access"
  type        = string
}

# Logic Toggle

variable "use_aurora" {
  description = "If true, creates an Aurora Cluster. If false, creates a standard RDS instance."
  type        = bool
  default     = false
}

# Database Configuration

variable "engine" {
  description = "The database engine (e.g., postgres, mysql, aurora-postgresql, aurora-mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "The instance type (e.g., db.t3.micro for RDS, db.t3.medium for Aurora)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_port" {
  description = "The port the database listens on"
  type        = number
  default     = 5432
}

# Storage & Scaling

variable "allocated_storage" {
  description = "Allocated storage in GB (Only used for standard RDS)"
  type        = number
  default     = 20
}

variable "replica_count" {
  description = "Number of Aurora instances in the cluster"
  type        = number
  default     = 1
}

# Credentials (Sensitive)

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "myappdb"
}

variable "db_username" {
  description = "Admin username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}