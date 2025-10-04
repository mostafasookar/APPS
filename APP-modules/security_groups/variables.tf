variable "name" {
  type        = string
  description = "Base name prefix for security groups"
  default     = "pgadmin"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "container_port" {
  type        = number
  description = "Port where ECS containers listen"
  default     = 80
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
