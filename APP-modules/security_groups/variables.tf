variable "name" {
  type        = string
  description = "Base name prefix for security groups"
  default     = "pgadmin"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "container_ports" {  # Changed from container_port to container_ports
  type        = list(number)
  default     = [80]
  description = "List of ports where ECS containers listen"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
