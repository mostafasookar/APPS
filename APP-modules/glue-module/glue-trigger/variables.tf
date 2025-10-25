# Variables for Glue Trigger Module

variable "jobs" {
  description = "List of Glue jobs (with trigger details if applicable)"
  # was: list(any)
  type        = list(any)
}

variable "dependency_modules" {
  description = "Dependencies that must exist before creating triggers (e.g., glue-manager)"
  type        = any
}

variable "tags" {
  description = "Default organizational tags for triggers"
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
