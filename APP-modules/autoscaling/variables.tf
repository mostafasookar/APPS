variable "name" {
  type        = string
  description = "Application name (used as prefix)"
}

variable "cluster_name" {
  type        = string
  description = "ECS Cluster name"
}

variable "service_name" {
  type        = string
  description = "ECS Service name"
}

variable "min_capacity" {
  type        = number
  default     = 1
}

variable "max_capacity" {
  type        = number
  default     = 3
}

variable "cpu_target_value" {
  type        = number
  default     = 70
  description = "Target CPU utilization % for autoscaling"
}

variable "memory_target_value" {
  type        = number
  default     = 75
  description = "Target Memory utilization % for autoscaling"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply where supported"
}
