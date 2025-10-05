############################
# Bring shared outputs
############################
data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "pgadmin-terraform-state-test"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

############################
# ECR (one repo for pgAdmin)
############################
module "ecr" {
  source = "../APP-modules/ecr"
  name   = local.app_name
  tags   = local.tags
}

############################
# IAM roles
############################
module "iam" {
  source = "../APP-modules/iam"
  name   = local.app_name
  tags   = local.tags
}

############################
# Security Group (for tasks)
############################
module "security_groups" {
  source          = "../APP-modules/security_groups"
  name            = local.app_name
  vpc_id          = data.terraform_remote_state.infra.outputs.vpc_id
  container_ports = [80] # Changed from container_port = 80 to container_ports = [80]
  tags            = local.tags
}

############################
# Secrets for login
############################
module "secrets" {
  source           = "../APP-modules/secrets"
  name             = local.app_name
  pgadmin_email    = var.pgadmin_email
  pgadmin_password = var.pgadmin_password
  tags             = local.tags
}

############################
# Logs (split per app)
############################
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${local.app_name}"
  retention_in_days = 14
  tags              = local.tags
}

############################
# Target Group + ALB Rule
############################
resource "aws_lb_target_group" "app" {
  name        = "${local.app_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  health_check {
    path                = "/misc/ping"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.tags, { Name = "${local.app_name}-tg" })
}

resource "aws_lb_listener_rule" "app" {
  listener_arn = data.terraform_remote_state.infra.outputs.alb_listener_arn_80
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = local.tags
}

############################
# Task Definition
############################
resource "aws_ecs_task_definition" "app" {
  family                   = "${local.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = module.iam.execution_role_arn
  task_role_arn            = module.iam.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "pgadmin"
      image     = "${module.ecr.repository_url}:${var.image_tag}"
      essential = true
      portMappings = [
        { containerPort = 80, hostPort = 80, protocol = "tcp" }
      ]
      mountPoints = [
        { sourceVolume = "efs-volume", containerPath = "/var/lib/pgadmin", readOnly = false }
      ]
      secrets = [
        { name = "PGADMIN_DEFAULT_EMAIL", valueFrom = "${module.secrets.pgadmin_secret_arn}:PGADMIN_DEFAULT_EMAIL::" },
        { name = "PGADMIN_DEFAULT_PASSWORD", valueFrom = "${module.secrets.pgadmin_secret_arn}:PGADMIN_DEFAULT_PASSWORD::" }
      ]
      environment = [
        { name = "PGADMIN_LISTEN_PORT", value = "80" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = data.terraform_remote_state.infra.outputs.region
          awslogs-stream-prefix = "pgadmin"
        }
      }
    }
  ])

  volume {
    name = "efs-volume"
    efs_volume_configuration {
      file_system_id     = data.terraform_remote_state.infra.outputs.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = data.terraform_remote_state.infra.outputs.efs_access_points["pgadmin"]
      }
    }
  }

  tags = local.tags
}

############################
# Service (shared cluster)
############################
resource "aws_ecs_service" "app" {
  name            = "${local.app_name}-service"
  cluster         = data.terraform_remote_state.infra.outputs.ecs_cluster_name
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.infra.outputs.private_subnet_ids
    assign_public_ip = false
    security_groups  = [module.security_groups.ecs_sg_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "pgadmin"
    container_port   = 80
  }

  deployment_controller { type = "ECS" }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  enable_execute_command = true

  tags = local.tags
}
