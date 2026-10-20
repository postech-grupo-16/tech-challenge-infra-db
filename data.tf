# Le a rede provisionada por tech-challenge-infra-k8s via SSM Parameter
# Store, sem acoplar o Terraform state dos dois repositorios (ver
# ssm-outputs.tf naquele repo).
data "aws_ssm_parameter" "vpc_id" {
  name = "/tech-challenge/vpc_id"
}

data "aws_ssm_parameter" "vpc_cidr" {
  name = "/tech-challenge/vpc_cidr"
}

data "aws_ssm_parameter" "subnet_ids" {
  name = "/tech-challenge/subnet_ids"
}

locals {
  vpc_id     = data.aws_ssm_parameter.vpc_id.value
  vpc_cidr   = data.aws_ssm_parameter.vpc_cidr.value
  subnet_ids = split(",", data.aws_ssm_parameter.subnet_ids.value)
}
