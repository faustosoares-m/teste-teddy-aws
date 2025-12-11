# Documentação de Entrega Final

## Arquitetura
- Diagrama: `docs/desenho.png`
- VPC `10.0.0.0/16` com 2 subnets públicas (ALB/NAT) e 2 privadas (tasks ECS), IGW e NAT Gateway.
- Security Group único liberando SSH:22 e HTTP:80 para `0.0.0.0/0` (aberto por ser teste).
- ECR: repositório `demo-app-new-relic-app` com scan on push e delete forçado.
- ECS Fargate: cluster `demo-app-new-relic-cluster`, serviço `demo-app-new-relic-service` com 2 tasks atrás de ALB público (`demo-app-new-relic-alb`) e target group HTTP:80.
- Logs: CloudWatch Log Group `/ecs/demo-app-new-relic`.
- IAM: roles separadas para execução ECS (`demo-app-new-relic-ecs-execution-role`) e task role (`demo-app-new-relic-ecs-task-role`); role/perfil EC2 para o módulo opcional.
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
- Alarme CloudWatch `demo-app-new-relic-ecs-high-cpu-alarm` para CPU >80% (namespace `AWS/ECS`, dimensão `ClusterName`). Logs no CloudWatch Logs. Circuit breaker de deployment habilitado.
