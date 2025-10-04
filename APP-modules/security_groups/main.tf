resource "random_string" "suffix" {
  length  = 5
  special = false
}

#####################################
# Security Group for ECS Tasks      #
#####################################
resource "aws_security_group" "ecs" {
  name        = "${var.name}-ecs-sg-${random_string.suffix.result}"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

#####################################
# Security Group for EFS            #
#####################################
resource "aws_security_group" "efs" {
  name        = "${var.name}-efs-sg-${random_string.suffix.result}"
  description = "Security group for EFS access"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
