variable "namespace_name" {
  description = "Cloud Map private DNS namespace (e.g. marquez.local)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the private namespace will be created"
  type        = string
}

variable "db_service_name" {
  description = "Service name for the DB (e.g. marquez-db)"
  type        = string
}

variable "api_service_name" {
  description = "Optional service name for API (e.g. marquez-api). Leave empty to skip creating API service."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# (Optional) light input validation
locals {
  _ns_has_dot = can(regex("\\.", var.namespace_name))
}
