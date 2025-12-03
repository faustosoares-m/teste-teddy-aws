# Alarme de CPU para o Cluster ECS (Exemplo de monitoramento mínimo)
resource "aws_cloudwatch_metric_alarm" "cluster_cpu_utilization" {
  alarm_name                = "teddy-ecs-high-cpu-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 5
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = 60 # segundos
  statistic                 = "Average"
  threshold                 = 1.5 # Acima de 80% de CPU
  alarm_description         = "Alerta se a utilização média da CPU do cluster for alta."
  unit                      = "Percent"
  
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = "teddy-service"
  }
}