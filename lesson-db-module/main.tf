module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = false
  aurora_instance_count      = 2

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.small"
  allocated_storage          = 20
  db_name                    = "myapp"              # to .env
  username                   = "postgres"           # to .env
  password                   = "admin123AWS23"      # to .env
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
} 
