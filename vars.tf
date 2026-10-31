variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto, usado para nomear os recursos"
  type        = string
  default     = "tech-challenge"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "tech_challenge"
}

variable "db_instance_class" {
  description = "Classe da instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento alocado (GB)"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "Versao do PostgreSQL"
  type        = string
  default     = "16"
}

# Preencha via terraform.tfvars (gitignored) ou TF_VAR_db_user / TF_VAR_db_pass.
# Sem default de proposito - nunca comite uma senha real.
variable "db_user" {
  description = "Usuario master do RDS"
  type        = string
  sensitive   = true
}

variable "db_pass" {
  description = "Senha master do RDS (minimo 8 caracteres)"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags aplicadas aos recursos"
  type        = map(string)
  default = {
    "Name" = "tech-challenge"
  }
}

variable "environment" {
  description = "Ambiente (production ou homolog) - define o sufixo dos nomes e o prefixo SSM"
  type        = string
  default     = "production"
}
