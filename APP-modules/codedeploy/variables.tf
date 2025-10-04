variable "name" {
  type        = string
  default     = "pgadmin"
  description = "Prefix for CodeDeploy resources"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name"
}

variable "codedeploy_role_arn" {
  type        = string
  description = "IAM role ARN for CodeDeploy"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}

variable "alb_listener_arn" {
  type        = string
  description = "ALB Listener ARN for CodeDeploy"
}
