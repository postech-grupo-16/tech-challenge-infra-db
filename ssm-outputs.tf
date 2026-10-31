# Publica o endpoint e as credenciais do RDS no SSM Parameter Store, para o
# CI de tech-challenge-app (popula o Secret/ConfigMap do Deployment) e a
# tech-challenge-auth-lambda (consulta direta ao Postgres) lerem sem
# acoplar Terraform state entre repositorios.
resource "aws_ssm_parameter" "rds_endpoint" {
  name  = "${local.ssm_prefix}/rds_endpoint"
  type  = "String"
  value = aws_db_instance.main.address
}

resource "aws_ssm_parameter" "rds_port" {
  name  = "${local.ssm_prefix}/rds_port"
  type  = "String"
  value = tostring(aws_db_instance.main.port)
}

resource "aws_ssm_parameter" "rds_db_name" {
  name  = "${local.ssm_prefix}/rds_db_name"
  type  = "String"
  value = aws_db_instance.main.db_name
}

resource "aws_ssm_parameter" "rds_user" {
  name  = "${local.ssm_prefix}/rds_user"
  type  = "SecureString"
  value = var.db_user
}

resource "aws_ssm_parameter" "rds_password" {
  name  = "${local.ssm_prefix}/rds_password"
  type  = "SecureString"
  value = var.db_pass
}
