variable "role_name" {
  description = "Name of the IAM role for AWS Glue"
  type        = string
  default     = "Sokar-GlueServiceRole"
}

variable "tags" {
  description = "Default organizational tags for resources"
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
