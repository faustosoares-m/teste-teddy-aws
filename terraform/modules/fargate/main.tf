data "aws_region" "current" {}


# 1. ECS Cluster

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/teddy"
  retention_in_days = 7
}


# 2. Application Load Balancer

resource "aws_lb" "alb" {
  name               = "teddy-alb"
  internal           = false
  load_balancer_type = "application"

  # O ALB usa as subnets públicas
  subnets            = var.public_subnet_ids 
  security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "tg" {
  name        = "teddy-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 10
    timeout = 5
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


# 3. ECS Task Definition

resource "aws_ecs_task_definition" "task" {
  family                   = "teddy-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "teddy-container"
      image     = var.ecr_image_url
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group.name
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


# 4. ECS Service

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  
  # Integração com o Load Balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "teddy-container"
    container_port   = 80
  }

  network_configuration {
    # subnets privadas para as tasks Fargate
    subnets         = var.private_subnet_ids 
    security_groups = [var.security_group_id]
    assign_public_ip = false
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  depends_on = [
    aws_lb_listener.listener,
    aws_lb_target_group.tg,
    aws_ecs_task_definition.task
  ]
}
