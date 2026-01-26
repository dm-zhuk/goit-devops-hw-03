variable "region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  description = "Name of your EKS cluster"
}

variable "instance_type" {
  type        = string
  description = "Worker node size (e.g. t3.medium)"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets for the nodes"
}

# Scaling Logic Variables
variable "desired_size" {
  type        = number
  description = "Number of nodes you want running"
}

variable "max_size" {
  type        = number
  description = "The absolute maximum nodes allowed"
}

variable "min_size" {
  type        = number
  description = "The absolute minimum nodes allowed"

  validation {
    condition     = var.min_size <= var.max_size
    error_message = "The min_size must be less than or equal to the max_size."
  }
}