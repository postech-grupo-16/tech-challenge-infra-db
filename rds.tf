resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = local.subnet_ids
  tags       = var.tags
}

resource "aws_db_instance" "main" {
  identifier     = "${local.name_prefix}-db"
  engine         = "postgres"
  engine_version = var.db_engine_version

  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_user
  password = var.db_pass
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Laboratorio academico (AWS Academy): sem backup automatico nem snapshot
  # final, para evitar custo/latencia extra em instancias de teste. Numa
  # instancia real de producao, ajuste backup_retention_period e
  # skip_final_snapshot = false.
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  apply_immediately = true

  tags = var.tags
}
