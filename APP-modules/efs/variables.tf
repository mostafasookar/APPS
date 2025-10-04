variable "name" {
  type        = string
  description = "Name prefix for EFS resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EFS will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EFS mount targets"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}

variable "create_security_group" {
  type        = bool
  default     = true
  description = "If true, create an SG that allows NFS from the VPC CIDR"
}

variable "security_group_id" {
  type        = string
  default     = null
  description = "If provided, use this SG for EFS mount targets instead of creating one"
}

variable "access_points" {
  description = "List of access points to create"
  type = list(object({
    name        = string
    path        = string
    uid         = number
    gid         = number
    permissions = string
  }))
  default = []
}
