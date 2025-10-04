# EFS (shared across apps like pgAdmin, Marquez)
module "efs" {
  source = "../APP-modules/efs"

  name       = "shared-efs"
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  tags       = local.tags

  create_security_group = true

  access_points = [
    {
      name        = "pgadmin"
      path        = "/pgadmin"
      uid         = 5050
      gid         = 5050
      permissions = "750"
    },
    {
      name        = "marquez"
      path        = "/marquez"
      uid         = 1000
      gid         = 1000
      permissions = "750"
    }
  ]
}

# VPC Endpoints
module "vpc_endpoints" {
  source = "../APP-modules/vpc_endpoints"

  name                    = "shared-vpce"
  vpc_id                  = var.vpc_id
  region                  = var.region
  subnet_ids              = var.private_subnet_ids
  private_route_table_ids = var.private_route_table_ids
  tags                    = local.tags
}
