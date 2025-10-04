variable "name" {
  type        = string
  description = "Name of the ECR repository"
  default     = "pgadmin"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to ECR resources"
  default     = {}
}
