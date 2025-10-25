########################################################
# Variables for Glue Job Module
########################################################

variable "job_name" {
  description = "Name of the Glue job"
  type        = string
}

variable "description" {
  description = "Description of the Glue job"
  type        = string
  default     = ""
}

variable "role_arn" {
  description = "IAM Role ARN for the Glue job"
  type        = string
}

variable "script_location" {
  description = "S3 path of the Glue job script"
  type        = string
}

variable "glue_version" {
  description = "Glue version (e.g. 5.0)"
  type        = string
  default     = "5.0"
}

variable "python_version" {
  description = "Python version"
  type        = string
  default     = "3"
}

variable "command_name" {
  description = "Command type (e.g. glueetl)"
  type        = string
  default     = "glueetl"
}

variable "worker_type" {
  description = "Worker type"
  type        = string
  default     = "G.2X"
}

variable "number_of_workers" {
  description = "Number of workers"
  type        = number
  default     = 2
}

variable "timeout" {
  description = "Timeout in minutes"
  type        = number
  default     = 300
}

variable "max_retries" {
  description = "Number of retries"
  type        = number
  default     = 0
}

variable "connections" {
  description = "List of Glue connections"
  type        = list(string)
  default     = []
}

variable "default_arguments" {
  description = "Map of default Glue arguments"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for the Glue job"
  type        = map(string)
  default     = {}
}

