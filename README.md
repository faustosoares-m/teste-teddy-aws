# Teste demo-app-new-relic AWS

Infraestrutura e app simples para teste: VPC completa, ECS Fargate atrás de ALB, repositório ECR e CI/CD via GitHub Actions.

## Estrutura
- `terraform/`: código de infra (backend remoto S3/DynamoDB, módulos de rede, segurança, IAM, ECR, Fargate e monitoramento; módulo EC2 opcional comentado).
- `app/`: Dockerfile Nginx com página que mostra metadados da task ECS.
- `infra/task-definition.json`: template usado pelo workflow de deploy.
- `.github/workflows/`: pipelines para provisionar/destroy infra e publicar/deploy do app.
- `docs/desenho.png`: insira aqui o diagrama de arquitetura (renomeie seu arquivo final para esse nome).

## Como usar
- Infra: `terraform init, terraform plan, terraform apply` em `terraform/` ou acione o workflow `Provisionamento de Infraestrutura (Terraform)`.
- App: acione o workflow `CI/CD APP (Build e Deploy ECS Fargate)`: ele faz build, push para o ECR e atualiza o serviço. Comandos manuais de build/tag/push estão em `app/README.md`.
- Destroy: `terraform destroy` ou workflow `Destruir Infraestrutura (Terraform Destroy)`.

Documentos detalhados:
- `docs/desenvolvimento.md`: guia de uso e comandos.
- `docs/entrega-final.md`: descrição da arquitetura, decisões e pontos de segurança/monitoramento.
