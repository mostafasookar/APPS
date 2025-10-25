# Variables for Glue Manager Module

variable "jobs" {
  description = "List of Glue jobs (merged from YAML)"
  # was: list(any)
  type        = list(map(any))
}

variable "scripts_root" {
  description = "Path to the folder containing Glue scripts"
  type        = string
}

variable "scripts_bucket" {
  description = "S3 bucket where Glue scripts are uploaded"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for Glue jobs"
  type        = string
}

variable "tags" {
  description = "Default organizational tags to apply (will merge with per-job tags)"
  type        = map(string)
  default = {
    ApplicationName     = "CDFundamentals"
    DataClassification  = "Confidential"
    BusinessCriticality = "Medium"
    BusinessUnit        = "DataPlatform"
    BusinessUnitOwner   = "Michael Joel De Groot"
    CostCenter          = "008"
    ManagedBy           = "Terraform"
  }
}
