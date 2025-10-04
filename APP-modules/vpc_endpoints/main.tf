############################
# Optional Endpoint SG
############################
resource "aws_security_group" "endpoints" {
  count       = var.sg_id == null ? 1 : 0
  name        = "${var.name}-vpce-sg"
  description = "Allow HTTPS from VPC for VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]# Restrict to VPC CIDR
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

locals {
  vpce_sg_id = var.sg_id != null ? var.sg_id : aws_security_group.endpoints[0].id
}

############################
# Interface Endpoints
############################

# ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [local.vpce_sg_id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.name}-ecr-api" })
}

# ECR DKR (image pulls)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [local.vpce_sg_id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.name}-ecr-dkr" })
}

# CloudWatch Logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [local.vpce_sg_id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.name}-logs" })
}

# Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [local.vpce_sg_id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.name}-secrets" })
}

# SSM endpoints for ECS Exec
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [local.vpce_sg_id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.name}-ssm" })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [local.vpce_sg_id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.name}-ssmmessages" })
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [local.vpce_sg_id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.name}-ec2messages" })
}

############################
# S3 Gateway Endpoint
############################
resource "aws_vpc_endpoint" "s3" {
  count             = length(var.private_route_table_ids) > 0 ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
  tags              = merge(local.common_tags, { Name = "${var.name}-s3" })
}
