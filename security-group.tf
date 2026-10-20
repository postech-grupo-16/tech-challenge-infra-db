# A VPC provisionada pelo infra-k8s so tem subnets publicas (projeto AWS
# Academy, sem NAT Gateway) - o isolamento do RDS vem do Security Group, nao
# de topologia de rede: so aceita trafego de dentro da propria VPC, na porta
# do Postgres. "publicly_accessible = false" (ver rds.tf) ja impede qualquer
# IP publico de alcancar a instancia.
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds"
  description = "Permite Postgres (5432) apenas de dentro da VPC do Tech Challenge"
  vpc_id      = local.vpc_id

  ingress {
    description = "Postgres a partir da VPC (EKS nodes, Lambda de auth)"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
