variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for pgAdmin deployment"
}

variable "image_tag" {
  type        = string
  default     = "latest"
  description = "ECR image tag for pgAdmin"
}

variable "pgadmin_email" {
  type        = string
  description = "Default pgAdmin admin email (from GitHub Secrets in CI/CD)"
}

variable "pgadmin_password" {
  type        = string
  description = "Default pgAdmin admin password (from GitHub Secrets in CI/CD)"
  sensitive   = true
}

variable "alert_email" {
  type        = string
  description = "Email address for CloudWatch alerts (optional)"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for ECS tasks"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for ALB"
}
