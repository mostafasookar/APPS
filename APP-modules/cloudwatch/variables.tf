variable "name" {
  type        = string
  description = "Application name (prefix for alarms and topics)"
}

variable "cluster_name" {
  type        = string
  description = "ECS Cluster name"
}

variable "service_name" {
  type        = string
  description = "ECS Service name"
}

variable "alert_email" {
  type        = string
  description = "Email to subscribe to SNS alerts"
}

variable "cpu_alarm_threshold" {
  type        = number
  default     = 80
  description = "CPU threshold % for alarm"
}

variable "memory_alarm_threshold" {
  type        = number
  default     = 85
  description = "Memory threshold % for alarm"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to SNS/alarms"
}
