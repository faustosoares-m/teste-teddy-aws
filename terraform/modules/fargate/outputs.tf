output "cluster_name" {
  description = "Nome do Cluster ECS"
  value       = aws_ecs_cluster.cluster.name
}

output "service_name" {
  description = "Nome do Serviço ECS"
  value       = aws_ecs_service.service.name
}

output "alb_dns_name" {
  description = "DNS Name do Application Load Balancer (URL de acesso)"
  value       = aws_lb.alb.dns_name
}