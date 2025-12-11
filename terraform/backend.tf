terraform {
  backend "s3" {
    bucket         = "demo-app-new-relic-terraform-state-917003953613"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-demo-app-new-relic"
    encrypt        = true
  }
}