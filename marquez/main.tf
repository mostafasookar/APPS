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
# ECR (3 repos)
############################
module "ecr_api" {
  source = "../APP-modules/ecr"
  name   = "${local.app_name}-api"
  tags   = local.tags
}

module "ecr_web" {
  source = "../APP-modules/ecr"
  name   = "${local.app_name}-web"
  tags   = local.tags
}

module "ecr_db" {
  source = "../APP-modules/ecr"
  name   = "${local.app_name}-db"
  tags   = local.tags
}

module "ecr_nginx" {
  source = "../APP-modules/ecr"
  name   = "${local.app_name}-nginx"
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

# Resolve the role name from ARN for attaching inline policy
data "aws_caller_identity" "current" {}

data "aws_iam_role" "task_role" {
  name       = trimprefix(module.iam.task_role_arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/")
  depends_on = [module.iam]
}

# Allow EFS client ops from task role
resource "aws_iam_role_policy" "task_efs" {
  name = "${local.app_name}-efs-access"
  role = data.aws_iam_role.task_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["elasticfilesystem:ClientMount", "elasticfilesystem:ClientWrite", "elasticfilesystem:ClientRootAccess"],
      Resource = "*"
    }]
  })
}

############################################
# Security Groups
############################################
# App SG: ALB -> nginx sidecar:8080 and (optionally) ALB -> api:5000
resource "aws_security_group" "marquez_app_sg" {
  name        = "${local.app_name}-app-sg"
  description = "App (api+web) SG"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  # ALB -> web-proxy (nginx) 8080
  ingress {
    description     = "ALB to web-proxy 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.infra.outputs.alb_sg_id]
  }

  # ALB -> API 5000 (keep if you want direct ALB path to API)
  ingress {
    description     = "ALB to api 5000"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.infra.outputs.alb_sg_id]
  }

  # Web -> API inside VPC (self-reachability on 5000 for Cloud Map calls)
  ingress {
    description = "App to API 5000 (self)"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

# DB SG: allow Postgres only from the App SG
resource "aws_security_group" "marquez_db_sg" {
  name        = "${local.app_name}-db-sg"
  description = "DB SG"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  ingress {
    description     = "App to DB 5432"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.marquez_app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

############################
# Secrets (DB creds)
############################
resource "random_string" "suffix" {
  length  = 5
  special = false
}

resource "aws_secretsmanager_secret" "db" {
  name        = "${local.app_name}-db-${random_string.suffix.result}"
  description = "Credentials for Marquez Postgres"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    POSTGRES_USER     = var.marquez_db_user
    POSTGRES_PASSWORD = var.marquez_db_password
    POSTGRES_DB       = var.marquez_db_name
  })
}

############################
# Logs
############################
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${local.app_name}"
  retention_in_days = 14
  tags              = local.tags
}

############################
# Target Groups + ALB Rules
############################
# WEB TG on :8080 (nginx sidecar)
resource "aws_lb_target_group" "web" {
  name        = "${local.app_name}-tg-web"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.tags, { Name = "${local.app_name}-tg-web" })
}

# API TG on :5000 (optional if WEB proxies via Cloud Map; keep for direct ALB API access)
resource "aws_lb_target_group" "api" {
  name        = "${local.app_name}-tg-api"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  health_check {
    path                = "/api/v1/namespaces"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.tags, { Name = "${local.app_name}-tg-api" })
}

# Web under /marquez/*
resource "aws_lb_listener_rule" "web" {
  listener_arn = data.terraform_remote_state.infra.outputs.alb_listener_arn_80
  priority     = 6

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  condition {
    path_pattern { values = [var.alb_path_prefix] } # e.g. "/marquez/*"
  }

  tags = local.tags
}

# API under /api/*
resource "aws_lb_listener_rule" "api" {
  listener_arn = data.terraform_remote_state.infra.outputs.alb_listener_arn_80
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    path_pattern { values = [var.alb_api_path_prefix] } # e.g. "/api/*"
  }

  tags = local.tags
}

############################
# Service Discovery (Cloud Map)
############################
module "service_discovery" {
  source           = "../APP-modules/service_discovery"
  namespace_name   = "marquez.local"
  db_service_name  = "marquez-db"  # -> marquez-db.marquez.local
  api_service_name = "marquez-api" # -> marquez-api.marquez.local
  vpc_id           = data.terraform_remote_state.infra.outputs.vpc_id
  tags             = local.tags
}

############################################
# DB TASK & SERVICE (separate)
############################################
resource "aws_ecs_task_definition" "db" {
  family                   = "${local.app_name}-db-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = module.iam.execution_role_arn
  task_role_arn            = module.iam.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "db",
      image     = "${module.ecr_db.repository_url}:${var.image_tag_db}",
      essential = true,
      environment = [
        { name = "POSTGRES_USER", value = var.marquez_db_user },
        { name = "POSTGRES_PASSWORD", value = var.marquez_db_password },
        { name = "POSTGRES_DB", value = var.marquez_db_name }
      ],
      portMappings = [{ containerPort = 5432, protocol = "tcp" }],
      healthCheck = {
        command     = ["CMD-SHELL", "pg_isready -U ${var.marquez_db_user} -d ${var.marquez_db_name} || exit 1"],
        interval    = 30,
        timeout     = 5,
        retries     = 5,
        startPeriod = 300
      },
      mountPoints = [
        { sourceVolume = "efs-postgres-volume", containerPath = "/var/lib/postgresql/data", readOnly = false }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "db"
        }
      }
    }
  ])

  volume {
    name = "efs-postgres-volume"
    efs_volume_configuration {
      file_system_id     = data.terraform_remote_state.infra.outputs.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = data.terraform_remote_state.infra.outputs.efs_access_points["marquez-postgres"]
        iam             = "ENABLED"
      }
    }
  }

  tags = local.tags
}

resource "aws_ecs_service" "db" {
  name                   = "${local.app_name}-db-service"
  cluster                = data.terraform_remote_state.infra.outputs.ecs_cluster_name
  task_definition        = aws_ecs_task_definition.db.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = data.terraform_remote_state.infra.outputs.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.marquez_db_sg.id]
  }

  # Register into Cloud Map -> marquez-db.marquez.local (A records → task ENI IPs)
  service_registries {
    registry_arn   = module.service_discovery.db_service_arn
    container_name = "db"
    # Do NOT set container_port with A records.
  }

  depends_on = [
    module.service_discovery
  ]

  deployment_controller { type = "ECS" }
  tags = local.tags
}

############################
# APP TASK (API + WEB + NGINX proxy)
############################
resource "aws_ecs_task_definition" "app" {
  family                   = "${local.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = module.iam.execution_role_arn
  task_role_arn            = module.iam.task_role_arn

  container_definitions = jsonencode([
    {
      "name" : "api",
      "image" : "${module.ecr_api.repository_url}:${var.image_tag_api}",
      "essential" : true,
      "portMappings" : [
        { "containerPort" : 5000, "protocol" : "tcp" },
        { "containerPort" : 5001, "protocol" : "tcp" }
      ],
      "environment" : [
        { "name" : "MARQUEZ_PORT", "value" : "5000" },
        { "name" : "MARQUEZ_ADMIN_PORT", "value" : "5001" },
        { "name" : "SEARCH_ENABLED", "value" : "false" },
        { "name" : "POSTGRES_HOST", "value" : "marquez-db.marquez.local" },
        { "name" : "POSTGRES_PORT", "value" : "5432" },
        { "name" : "MARQUEZ_CONFIG", "value" : "/opt/marquez/marquez.yml" }
      ],
      "secrets" : [
        { "name" : "POSTGRES_USER", "valueFrom" : "${aws_secretsmanager_secret.db.arn}:POSTGRES_USER::" },
        { "name" : "POSTGRES_PASSWORD", "valueFrom" : "${aws_secretsmanager_secret.db.arn}:POSTGRES_PASSWORD::" },
        { "name" : "MARQUEZ_DB", "valueFrom" : "${aws_secretsmanager_secret.db.arn}:POSTGRES_DB::" }
      ],
      "mountPoints" : [
        { "sourceVolume" : "efs-api-volume", "containerPath" : "/opt/marquez", "readOnly" : false }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.app.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "api"
        }
      },
      "healthCheck" : {
        "command" : ["CMD-SHELL", "curl -sf http://127.0.0.1:5000/api/v1/namespaces >/dev/null || exit 1"],
        "interval" : 30,
        "timeout" : 5,
        "retries" : 5,
        "startPeriod" : 180
      }
    },
    {
      "name" : "web",
      "image" : "${module.ecr_web.repository_url}:${var.image_tag_web}",
      "essential" : true,
      "portMappings" : [
        { "containerPort" : 3000, "protocol" : "tcp" }
      ],
      "environment" : [
        { "name" : "WEB_PORT", "value" : "3000" },
        { "name" : "MARQUEZ_HOST", "value" : "marquez-api.marquez.local" },
        { "name" : "MARQUEZ_PORT", "value" : "5000" },
        { "name" : "PROXY_CHANGE_ORIGIN", "value" : "true" },
        { "name" : "REACT_APP_MARQUEZ_API_URL", "value" : "/api" }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.app.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "web"
        }
      },
      "dependsOn" : [
        { "containerName" : "api", "condition" : "HEALTHY" }
      ]
    },
    {
      "name" : "web-proxy",
      "image" : "${module.ecr_nginx.repository_url}:${var.image_tag_nginx}",
      "essential" : true,
      "portMappings" : [
        { "containerPort" : 8080, "protocol" : "tcp" }
      ],
      "dependsOn" : [
        { "containerName" : "web", "condition" : "START" }
      ],
      "mountPoints" : [
        { "sourceVolume" : "efs-api-volume", "containerPath" : "/opt/marquez", "readOnly" : true }
      ],
      "command" : ["nginx", "-g", "daemon off;", "-c", "/opt/marquez/nginx/nginx.conf"],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.app.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "web-proxy"
        }
      },
      "healthCheck" : {
        "command" : ["CMD-SHELL", "curl -sf http://127.0.0.1:8080/health >/dev/null || exit 1"],
        "interval" : 30,
        "timeout" : 5,
        "retries" : 3,
        "startPeriod" : 30
      }
    }
  ])

  volume {
    name = "efs-api-volume"
    efs_volume_configuration {
      file_system_id     = data.terraform_remote_state.infra.outputs.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = data.terraform_remote_state.infra.outputs.efs_access_points["marquez-api"]
        iam             = "ENABLED"
      }
    }
  }

  tags = local.tags
}

############################
# APP SERVICE (api + web behind ALB)
############################
resource "aws_ecs_service" "app" {
  name                   = "${local.app_name}-service"
  cluster                = data.terraform_remote_state.infra.outputs.ecs_cluster_name
  task_definition        = aws_ecs_task_definition.app.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = data.terraform_remote_state.infra.outputs.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.marquez_app_sg.id]
  }

  # Web listener -> nginx sidecar on 8080
  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web-proxy"
    container_port   = 8080
  }

  # API listener (optional; keep if you want direct ALB path to API)
  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api"
    container_port   = 5000
  }

  # Register API into Cloud Map (A records → task ENI IPs). No container_port for A-records.
  service_registries {
    registry_arn   = module.service_discovery.api_service_arn
    container_name = "api"
  }

  depends_on = [
    module.service_discovery,
    aws_ecs_service.db
  ]

  deployment_controller { type = "ECS" }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = local.tags
}
