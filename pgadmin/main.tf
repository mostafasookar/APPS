# Import shared infra (terraform/ state)
data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "pgadmin-terraform-state-test"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

# ECR Repo
module "ecr" {
  source = "../APP-modules/ecr"
  name   = local.app_name
  tags   = local.tags
}

# IAM Roles
module "iam" {
  source = "../APP-modules/iam"
  name   = local.app_name
  tags   = local.tags
}

# Security Groups
module "security_groups" {
  source         = "../APP-modules/security_groups"
  name           = local.app_name
  vpc_id         = var.vpc_id
  container_port = 80
  tags           = local.tags
}

# Secrets
module "secrets" {
  source           = "../APP-modules/secrets"
  name             = local.app_name
  pgadmin_email    = var.pgadmin_email
  pgadmin_password = var.pgadmin_password
  tags             = local.tags
}

# ALB
module "alb" {
  source            = "../APP-modules/alb"
  name              = local.app_name
  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids
  sg_id             = module.security_groups.ecs_sg_id
  container_port    = 80
  tags              = local.tags
}

# ECS
module "ecs" {
  source               = "../APP-modules/ecs"
  name                 = local.app_name
  execution_role_arn   = module.iam.execution_role_arn
  task_role_arn        = module.iam.task_role_arn
  ecr_repo_url         = module.ecr.repository_url
  image_tag            = var.image_tag
  efs_id               = data.terraform_remote_state.infra.outputs.efs_id
  efs_access_point_id  = data.terraform_remote_state.infra.outputs.efs_access_points[local.app_name]
  ecs_sg_id            = module.security_groups.ecs_sg_id
  alb_target_group_arn = module.alb.target_group_arn
  private_subnet_ids   = var.private_subnet_ids
  public_subnet_ids    = var.public_subnet_ids
  pgadmin_secret_arn   = module.secrets.pgadmin_secret_arn
  region               = var.region
  tags                 = local.tags
}

# Autoscaling
module "pgadmin_autoscaling" {
  source              = "../APP-modules/autoscaling"
  name                = local.app_name
  cluster_name        = module.ecs.ecs_cluster_name
  service_name        = module.ecs.ecs_service_name
  min_capacity        = 1
  max_capacity        = 3
  cpu_target_value    = 70
  memory_target_value = 75
  tags                = local.tags
}

# CloudWatch
module "pgadmin_cloudwatch" {
  source                 = "../APP-modules/cloudwatch"
  name                   = local.app_name
  cluster_name           = module.ecs.ecs_cluster_name
  service_name           = module.ecs.ecs_service_name
  alert_email            = var.alert_email
  cpu_alarm_threshold    = 80
  memory_alarm_threshold = 85
  tags                   = local.tags
}
