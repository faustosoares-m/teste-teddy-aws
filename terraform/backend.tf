terraform {
  backend "s3" {
    bucket         = "teddy-terraform-state-917003953613"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-teddy"
    encrypt        = true
  }
}