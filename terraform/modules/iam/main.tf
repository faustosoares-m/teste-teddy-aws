
# IAM Role para EC2

resource "aws_iam_role" "ec2_role" {
  name = "demo-app-new-relic-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "demo-app-new-relic-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}


# IAM Role para execução ECS

resource "aws_iam_role" "ecs_execution_role" {
  name = "demo-app-new-relic-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# IAM Role para ECS

resource "aws_iam_role" "ecs_task_role" {
  name = "demo-app-new-relic-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}
