variable "name" {
  type        = string
  description = "Base name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ALB"
}

variable "sg_id" {
  type        = string
  description = "Security group for ALB"
}

variable "container_port" {
  type        = number
  default     = 80
  description = "Container port that ALB will forward traffic to"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply"
}
