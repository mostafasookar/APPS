locals {
  app_name = "marquez"

  tags = {
    Application = local.app_name
    Owner       = "DataPlatform"
    ManagedBy   = "Terraform"
  }
}
