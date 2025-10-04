locals {
  common_tags = merge(
    {
      Application = var.name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
