variable "cluster_name" {
  description = "Nome do Cluster ECS"
  type        = string
  default     = "teddy-cluster"
}

variable "service_name" {
  description = "Nome do Serviço ECS"
  type        = string
  default     = "teddy-service"
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "security_group_id" {
  description = "ID do SG"
  type        = string
}

variable "ecr_image_url" {
  description = "URL completa da imagem ECR"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN da Role de Execução do ECS (Execution Role)"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas para as tasks do Fargate"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "IDs das subnets públicas para o Application Load Balancer"
  type        = list(string)
}