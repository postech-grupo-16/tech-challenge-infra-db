# Tech Challenge — Infra Banco de Dados (RDS)

Terraform que provisiona o banco de dados gerenciado (RDS PostgreSQL) do Tech Challenge, substituindo o PostgreSQL que antes rodava dentro do cluster EKS (StatefulSet).

Faz parte do conjunto de 4 repositórios da Fase 3 do Tech Challenge (16SOAT):

| Repositório | Responsabilidade |
|---|---|
| [tech-challenge-app](https://github.com/Gabrielfsg/tech-challenge-app) | API Spring Boot + manifests K8s da aplicação + CI/CD |
| [tech-challenge-infra-k8s](https://github.com/Gabrielfsg/tech-challenge-infra-k8s) | Terraform: VPC, cluster EKS, node group, ECR |
| **tech-challenge-infra-db** (este) | Terraform: banco de dados gerenciado (RDS PostgreSQL) |
| [tech-challenge-auth-lambda](https://github.com/Gabrielfsg/tech-challenge-auth-lambda) | Function Serverless de autenticação via CPF + API Gateway |

## Dependência

Precisa que o [tech-challenge-infra-k8s](https://github.com/Gabrielfsg/tech-challenge-infra-k8s) já tenha sido aplicado — este repositório lê `vpc_id`, `vpc_cidr` e `subnet_ids` do SSM Parameter Store (publicados por aquele repo em `ssm-outputs.tf`), em vez de acoplar o Terraform state dos dois repositórios.

## O que provisiona

- Instância RDS PostgreSQL 16 (`db.t3.micro`, 20GB `gp3`) — `publicly_accessible = false`
- `DB Subnet Group` usando as subnets da VPC do `tech-challenge-infra-k8s`
- Security Group liberando a porta 5432 **só para tráfego de dentro da própria VPC** (sem subnets privadas no projeto — AWS Academy não usa NAT Gateway; o isolamento vem do Security Group, não da topologia de rede)
- Publica no SSM Parameter Store: endpoint, porta, nome do banco (`String`) e usuário/senha (`SecureString`) em `/tech-challenge/rds_*`, para o [tech-challenge-app](https://github.com/Gabrielfsg/tech-challenge-app) (popula o K8s Secret/ConfigMap no deploy) e a [tech-challenge-auth-lambda](https://github.com/Gabrielfsg/tech-challenge-auth-lambda) (consulta direta ao Postgres) lerem

## Pré-requisitos

- Terraform ≥ 1.5
- AWS CLI configurado (AWS Academy: credenciais temporárias do Learner Lab)
- `tech-challenge-infra-k8s` já aplicado (ver acima)

## Uso

```bash
cp terraform.tfvars.example terraform.tfvars
# edite terraform.tfvars com usuário/senha reais

terraform init
terraform plan
terraform apply
```

```bash
terraform output jdbc_url   # URL JDBC pronta para SPRING_DATASOURCE_URL
```

## Derrubando

```bash
terraform destroy
```

> ⚠️ A instância RDS gera cobrança contínua. Rode `terraform destroy` assim que terminar os testes. `skip_final_snapshot = true` e `backup_retention_period = 0` são escolhas deliberadas para um ambiente de laboratório — numa instância real de produção, ajuste ambos.

## CI/CD

[`.github/workflows/terraform.yml`](.github/workflows/terraform.yml): `plan` em todo push/dispatch, `apply` automático em push na `main`, `destroy` manual via `workflow_dispatch`. Requer os secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` (credenciais do AWS Academy Learner Lab) e `TF_VAR_DB_USER`, `TF_VAR_DB_PASS` (credenciais do banco).

A branch `main` é protegida — merges só via Pull Request.

---

Desenvolvido como Tech Challenge — Pós-Graduação em Arquitetura de Software (FIAP/16SOAT).
