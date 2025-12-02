resource "aws_ecr_repository" "repo" {
  name = var.name

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
  

  tags = {
    Name = var.name
  }
}
