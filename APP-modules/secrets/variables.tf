variable "name" {
  type        = string
  description = "Prefix for the secret name"
  default     = "pgadmin"
}

variable "pgadmin_email" {
  type        = string
  description = "Default pgAdmin login email"
}

variable "pgadmin_password" {
  type        = string
  description = "Default pgAdmin login password"
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Tags for the secret"
  default     = {}
}
