variable "name" {
  type        = string
  description = "Prefix for resources"
  default     = "pgadmin"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnets for interface endpoints"
}

variable "sg_id" {
  type        = string
  default     = null
  description = "Optional SG for endpoints; if null, one is created"
}

variable "private_route_table_ids" {
  type        = list(string)
  default     = []
  description = "Private route table IDs for S3 Gateway endpoint"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags"
}
