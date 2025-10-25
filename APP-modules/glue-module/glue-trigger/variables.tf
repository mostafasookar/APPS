variable "jobs" {
  description = "List of Glue jobs with trigger configs"
  type        = list(any)
}

variable "dependency_modules" {
  description = "Dependent modules (e.g., glue-manager)"
  type        = any
}

variable "tags" {
  description = "Default tags for triggers"
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
