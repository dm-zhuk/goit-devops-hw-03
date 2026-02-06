# --- Database Connection Info ---

output "db_hostname" {
  description = "The address of the database"
  value       = module.rds.db_endpoint
}

output "db_port" {
  description = "The port for database connection"
  value       = module.rds.db_port
}

output "django_database_url" {
  description = "Formatted URL for Django .env file"
  sensitive   = true
  value       = "postgres://${var.username}:${var.password}@${module.rds.db_endpoint}:${module.rds.db_port}/${var.db_name}"
}

# --- Infrastructure References ---

output "rds_security_group_id" {
  description = "Security Group ID of the database"
  value       = module.rds.db_security_group_id
}

output "is_aurora_enabled" {
  description = "Confirmation if Aurora was used"
  value       = var.use_aurora
}