# Documentação de Entrega Final

## Arquitetura
- Diagrama: `docs/desenho.png`
- VPC `10.0.0.0/16` com 2 subnets públicas (ALB/NAT) e 2 privadas (tasks ECS), IGW e NAT Gateway.
- Security Group único liberando SSH:22 e HTTP:80 para `0.0.0.0/0` (aberto por ser teste).
- ECR: repositório `teddy-app` com scan on push e delete forçado.
- ECS Fargate: cluster `teddy-cluster`, serviço `teddy-service` com 2 tasks atrás de ALB público (`teddy-alb`) e target group HTTP:80.
- Logs: CloudWatch Log Group `/ecs/teddy`.
- IAM: roles separadas para execução ECS (`teddy-ecs-execution-role`) e task role (`teddy-ecs-task-role`); role/perfil EC2 para o módulo opcional.
- Módulo EC2 opcional (comentado) para criar instância Amazon Linux com Docker.

## Decisões e boas práticas
- State remoto em S3 com lock em DynamoDB.
- Tasks em subnets privadas sem IP público; exposição só via ALB.
- IAM mínimo necessário para execução das tasks; repositório ECR dedicado.

## CI/CD
- `infra-apply.yaml`: aplica Terraform (init, validate, plan, apply) manual via `workflow_dispatch`.
- `infra-destroy.yaml`: destroy manual.
- `app-deploy.yaml`: build da imagem do `app/`, push para ECR (tag curta do commit e `latest`), render de `infra/task-definition.json` e deploy no serviço ECS.
- Secrets necessários: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

## Monitoramento
- Alarme CloudWatch `teddy-ecs-high-cpu-alarm` para CPU >80% (namespace `AWS/ECS`, dimensão `ClusterName`). Logs no CloudWatch Logs. Circuit breaker de deployment habilitado.
