############################
# Shared ECS Cluster
############################
resource "aws_ecs_cluster" "shared" {
  name = "shared-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(local.tags, { Name = "shared-ecs-cluster" })
}

############################
# Shared ALB + SG
############################
resource "aws_security_group" "alb" {
  name        = "shared-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # (Optional) Enable 443 later
  # ingress { ... }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "shared-alb-sg" })
}

resource "aws_lb" "shared" {
  name               = "shared-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = merge(local.tags, { Name = "shared-alb" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.shared.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

############################
# Shared EFS (per-app APs)
############################
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
      name        = "marquez-postgres"
      path        = "/var/lib/postgresql/data"
      uid         = 999 # Typical PostgreSQL user UID, adjust if needed
      gid         = 999 # Typical PostgreSQL group GID, adjust if needed
      permissions = "775"
    },
    {
      name        = "marquez-api"
      path        = "/opt/marquez"
      uid         = 1000 # Match API container user, adjust if needed
      gid         = 1000 # Match API container group, adjust if needed
      permissions = "775"
    }
  ]
}

############################
# VPC Interface Endpoints
############################
module "vpc_endpoints" {
  source = "../APP-modules/vpc_endpoints"

  name                    = "shared-vpce"
  vpc_id                  = var.vpc_id
  region                  = var.region
  subnet_ids              = var.private_subnet_ids
  private_route_table_ids = var.private_route_table_ids
  tags                    = local.tags
}

############################
# GLUE ROLE
############################
module "glue_role" {
  source = "../APP-modules/glue-role"
}

##################################
# GLUE JOBS
################################
module "glue_jobs" {
  source = "../APP-modules/glue-jobs"

  scripts_bucket = "glue-sokar-test"
  role_arn       = module.glue_role.glue_role_arn
  glue_version   = "5.0"
  python_version = "3"
  command_name   = "glueetl"

  default_arguments = {
    "--TempDir"             = "s3://glue-sokar-test/temp/"
    "--enable-metrics"      = "true"
    "--enable-job-insights" = "true"
  }

  tags = {
    Owner       = "Moustafa"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
