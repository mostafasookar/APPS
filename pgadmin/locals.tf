locals {
  app_name = "pgadmin"

  tags = {
    Application = local.app_name
    Owner       = "DataPlatform"
  }
}
