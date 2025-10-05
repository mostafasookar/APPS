variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

# Image tags (use Docker Hub images unless you build/push your own to ECR)
variable "image_tag_api" {
  type        = string
  default     = "latest"
  description = "Tag for marquezproject/marquez (API)"
}

variable "image_tag_web" {
  type        = string
  default     = "latest"
  description = "Tag for marquezproject/marquez-web (WEB)"
}

variable "image_tag_db" {
  type        = string
  default     = "latest"
  description = "Tag for postgres"
}

variable "image_tag_search" {
  type        = string
  default     = "latest"
  description = "Tag for opensearchproject/opensearch"
}

variable "marquez_db_user" {
  type        = string
  default     = "marquez"
  description = "Postgres username for Marquez"
}

variable "marquez_db_password" {
  type        = string
  default     = "ChangeMe123!"
  description = "Postgres password for Marquez"
  sensitive   = true
}

variable "marquez_db_name" {
  type        = string
  default     = "marquez"
  description = "Postgres database name"
}

# Path-based routing prefix on the shared ALB
variable "alb_path_prefix" {
  type        = string
  default     = "/marquez/*"
  description = "Listener rule path pattern for Marquez web"
}

# Task size (all 4 containers in one task)
variable "task_cpu" {
  type    = string
  default = "4096"
}
variable "task_memory" {
  type    = string
  default = "8192"
}

# Path on the ALB that routes to the API TG
variable "alb_api_path_prefix" {
  type        = string
  description = "Path prefix on ALB to route to the API target group"
  default     = "/api/*"
}

variable "image_tag_nginx" {
  description = "Tag for the nginx sidecar image"
  type        = string
  default     = "latest"
}
