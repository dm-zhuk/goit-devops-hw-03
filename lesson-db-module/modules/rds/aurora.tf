resource "aws_rds_cluster" "this" {
  count                  = var.use_aurora ? 1 : 0
  cluster_identifier     = "${var.project_name}-aurora-cluster"
  engine                 = var.engine
  database_name          = var.db_name
  master_username        = var.username
  master_password        = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.use_aurora ? var.replica_count : 0
  identifier         = "${var.project_name}-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this[0].engine
}