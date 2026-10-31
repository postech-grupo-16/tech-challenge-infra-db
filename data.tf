# Le a rede provisionada por tech-challenge-infra-k8s (do mesmo ambiente) via
# SSM Parameter Store, sem acoplar o Terraform state dos dois repositorios
# (ver ssm-outputs.tf naquele repo).
data "aws_ssm_parameter" "vpc_id" {
  name = "${local.ssm_prefix}/vpc_id"
}

data "aws_ssm_parameter" "vpc_cidr" {
  name = "${local.ssm_prefix}/vpc_cidr"
}

data "aws_ssm_parameter" "subnet_ids" {
  name = "${local.ssm_prefix}/subnet_ids"
}

locals {
  vpc_id     = data.aws_ssm_parameter.vpc_id.value
  vpc_cidr   = data.aws_ssm_parameter.vpc_cidr.value
  subnet_ids = split(",", data.aws_ssm_parameter.subnet_ids.value)
}
