variable "project_name" { type = string }
variable "name" { type = string }
variable "use_aurora" { type = bool }
variable "instance_class" { type = string }

variable "engine" { type = string }
variable "engine_version" { type = string }
variable "engine_cluster" { type = string }
variable "engine_version_cluster" { type = string }

variable "db_name" { type = string }
variable "username" { type = string }
variable "password" { type = string, sensitive = true }

variable "vpc_id" { type = string }
variable "subnet_private_ids" { type = list(string) }
variable "subnet_public_ids" { type = list(string) }
variable "eks_node_sg_id" { type = string }

variable "multi_az" { type = bool }
variable "backup_retention_period" { type = number }
variable "parameters" { type = map(string) }
variable "tags" { type = map(string) }