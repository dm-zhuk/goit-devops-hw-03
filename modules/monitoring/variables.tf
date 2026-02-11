variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Namespace where Prometheus and Grafana will be deployed"
}

variable "project_name" {
  type        = string
  description = "Project prefix for naming resources"
}

variable "tags" {
  type        = map(string)
  description = "Common tags for monitoring resources"
  default     = {}
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
}