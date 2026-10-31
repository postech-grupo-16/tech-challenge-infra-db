locals {
  # Em producao os nomes ficam exatamente como antes (sem sufixo), para nao
  # forcar a recriacao do RDS; os demais ambientes ganham o sufixo
  # (ex.: tech-challenge-homolog-db, /tech-challenge-homolog/rds_endpoint).
  # Precisa bater com o mesmo calculo em tech-challenge-infra-k8s, de onde
  # vem a rede lida em data.tf.
  name_prefix = var.environment == "production" ? var.project_name : "${var.project_name}-${var.environment}"
  ssm_prefix  = "/${local.name_prefix}"
}
