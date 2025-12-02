variable "subnet_id" {
  description = "Subnet pública"
  type        = string
}

variable "security_group_id" {
  description = "SG para EC2"
  type        = string
}

variable "instance_profile" {
  description = "IAM para EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "teddy-key"
  type        = string
}
