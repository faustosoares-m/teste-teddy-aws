# Documentação de Desenvolvimento

Guia rápido para provisionar a infra, publicar a imagem e atualizar o serviço ECS.

## Pré-requisitos
- Credenciais AWS com permissão em S3/DynamoDB (state), ECR, ECS, EC2, VPC e IAM. Exportar `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` e `AWS_REGION=us-east-1` ou configurar perfil.
- Terraform instalado (>=1.6 recomendado).
- Docker instalado (para builds locais).
- Para GitHub Actions: definir os secrets `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` no repositório.

## Provisionar infraestrutura
Dentro de `terraform/`:
```sh
terraform init      # backend S3/DynamoDB já configurado em backend.tf
terraform plan
terraform apply
```
Módulos criados: rede (VPC, subnets, IGW, NAT), SG, IAM, ECR, ECS Fargate + ALB, monitoramento (alarme CPU).

### Módulo EC2 (opcional, estapas 1 e 2)
O bloco `module "compute_ec2"` está comentado em `terraform/main.tf`. Para criar uma instância pública com Docker pré-instalado, descomente, ajuste `key_name` se necessário e rode `terraform apply`.

## Deploy do app
Acionar manualmente o workflow GitHub Actions `CI/CD APP (Build e Deploy ECS Fargate)`:
1. Faz login no ECR.
2. Builda a imagem do `app/` e publica com tag curta do commit e `latest`.
3. Renderiza `infra/task-definition.json` com a imagem e faz deploy no serviço ECS.


## Destruir infraestrutura
```sh
terraform destroy
```
Ou use o workflow `Destruir Infraestrutura (Terraform Destroy)`.

## Referências rápidas
- `app/README.md`: comandos de build/tag/push.
- `.github/workflows/infra-apply.yaml`: pipeline para aplicar Terraform.
- `.github/workflows/app-deploy.yaml`: pipeline de deploy do app.
- `infra/task-definition.json`: template usado no deploy via workflow.
