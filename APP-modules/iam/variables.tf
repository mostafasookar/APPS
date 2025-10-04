variable "name" {
  description = "Prefix name for IAM roles"
  type        = string
}

variable "tags" {
  description = "Tags for IAM resources"
  type        = map(string)
  default     = {}
}
