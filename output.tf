output "rds_endpoint" {
  description = "Endpoint (host) do RDS"
  value       = aws_db_instance.main.address
}

output "rds_port" {
  value = aws_db_instance.main.port
}

output "rds_db_name" {
  value = aws_db_instance.main.db_name
}

output "jdbc_url" {
  description = "URL JDBC completa para SPRING_DATASOURCE_URL"
  value       = "jdbc:postgresql://${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
}
