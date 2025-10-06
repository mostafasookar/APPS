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
  default     = "vpc-0acff19cbcdd28123"
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type = list(string)
  default = [
    "subnet-0f15865ff763a4cd2",
    "subnet-05fe1790c8745cf07",
    "subnet-05a98b6683351fe11"
  ]
  description = "Private subnets for ECS tasks"
}

variable "public_subnet_ids" {
  type = list(string)
  default = [
    "subnet-0096b55bfec0fc1b7",
    "subnet-0baa7f08adef5addb",
    "subnet-03be7e34785dcc9ed"
  ]
  description = "Public subnets for ALB"
}
