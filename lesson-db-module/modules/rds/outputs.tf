output "db_instance_id" {
  description = "The ID of the RDS instance (if use_aurora is false)"
  value       = !var.use_aurora ? aws_db_instance.this[0].id : null
}

output "db_cluster_id" {
  description = "The ID of the Aurora Cluster (if use_aurora is true)"
  value       = var.use_aurora ? aws_rds_cluster.this[0].id : null
}

output "db_endpoint" {
  description = "The connection endpoint (Hostname) for the database"
  # Logic: If aurora is true, take cluster endpoint; else take instance address
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "db_port" {
  description = "The port the database is listening on"
  value       = var.use_aurora ? (var.engine == "postgres" || var.engine == "aurora-postgresql" ? 5432 : 3306) : aws_db_instance.this[0].port
}

output "db_name" {
  description = "The name of the database created"
  value       = var.db_name
}

output "db_security_group_id" {
  description = "The ID of the security group created for the database"
  value       = aws_security_group.db_sg.id
}