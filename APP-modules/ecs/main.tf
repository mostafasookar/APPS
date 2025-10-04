##############################
# ECS Cluster for pgAdmin    #
##############################

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(local.common_tags, { Name = "${var.name}-cluster" })
}

##############################
# CloudWatch Logs            #
##############################
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.name}"
  retention_in_days = 14
  tags              = local.common_tags
}

##############################
# Task Definition for pgAdmin #
##############################

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "pgadmin"
      image     = "${var.ecr_repo_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "efs-volume"
          containerPath = "/var/lib/pgadmin"
          readOnly      = false
        }
      ]
      secrets = [
        {
          name      = "PGADMIN_DEFAULT_EMAIL"
          valueFrom = "${var.pgadmin_secret_arn}:PGADMIN_DEFAULT_EMAIL::"
        },
        {
          name      = "PGADMIN_DEFAULT_PASSWORD"
          valueFrom = "${var.pgadmin_secret_arn}:PGADMIN_DEFAULT_PASSWORD::"
        }
      ]
      environment = [
        {
          name  = "PGADMIN_LISTEN_PORT"
          value = "80"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = "efs-volume"
    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.efs_access_point_id
      }
    }
  }

  tags = local.common_tags
}

##############################
# ECS Service for pgAdmin    #
##############################

resource "aws_ecs_service" "this" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [var.ecs_sg_id]
  }

  # Attach ECS tasks to ALB target group
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "pgadmin"
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  enable_execute_command = true

  tags = local.common_tags
}
