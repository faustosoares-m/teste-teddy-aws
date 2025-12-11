# Alarme de CPU para o Cluster ECS (Exemplo de monitoramento mínimo)
resource "aws_cloudwatch_metric_alarm" "cluster_cpu_utilization" {
  alarm_name                = "demo-app-new-relic-ecs-high-cpu-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = 60 # segundos
  statistic                 = "Average"
  threshold                 = 1.5 # Acima de 10% de CPU que foi o que meu app consegue atigir, configure conforme necessário
  alarm_description         = "Alerta se a utilização média da CPU do cluster for alta."
  unit                      = "Percent"
  
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = "demo-app-new-relic-service"
  }
}