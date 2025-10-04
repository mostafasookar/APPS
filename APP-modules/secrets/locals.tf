locals {
  common_tags = merge(
    {
      Application = "pgadmin"
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
