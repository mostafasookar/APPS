variable "jobs" {
  description = "List of Glue jobs (from YAML)"
  type        = list(any)
}

variable "scripts_root" {
  description = "Local folder containing Glue scripts"
  type        = string
}

variable "scripts_bucket" {
  description = "S3 bucket where Glue scripts are uploaded"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for Glue"
  type        = string
}

variable "tags" {
  description = "Default tags merged with job-level tags"
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
