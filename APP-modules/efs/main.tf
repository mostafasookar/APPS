data "aws_vpc" "this" {
  id = var.vpc_id
}

# Optional SG creation (allow NFS from VPC CIDR)
resource "aws_security_group" "efs" {
  count  = var.create_security_group && var.security_group_id == null ? 1 : 0
  name   = "${local.name}-efs-sg"
  vpc_id = var.vpc_id
  tags   = merge(local.tags, { Name = "${local.name}-efs-sg" })

  ingress {
    description = "Allow NFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  efs_sg_id = var.security_group_id != null ? var.security_group_id : (
    var.create_security_group ? aws_security_group.efs[0].id : null
  )
}

resource "aws_efs_file_system" "this" {
  creation_token = local.name
  encrypted      = true
  tags           = merge(local.tags, { Name = "${local.name}-efs" })
}

# One mount target per private subnet
resource "aws_efs_mount_target" "this" {
  for_each = { for idx, sid in var.subnet_ids : idx => sid }

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = local.efs_sg_id == null ? [] : [local.efs_sg_id]
}

# Create multiple access points, one per app (pgadmin, marquez, ...)
resource "aws_efs_access_point" "ap" {
  for_each      = { for ap in var.access_points : ap.name => ap }
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = each.value.path
    creation_info {
      owner_uid   = each.value.uid
      owner_gid   = each.value.gid
      permissions = each.value.permissions
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name}-ap-${each.key}"
    App  = each.key
  })
}
