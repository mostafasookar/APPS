# ECS
output "ecs_cluster_name" {
  value       = aws_ecs_cluster.shared.name
  description = "Shared ECS cluster name"
}

# ALB
output "alb_arn" {
  value       = aws_lb.shared.arn
  description = "Shared ALB ARN"
}
output "alb_dns_name" {
  value       = aws_lb.shared.dns_name
  description = "Shared ALB DNS name"
}
output "alb_listener_arn_80" {
  value       = aws_lb_listener.http.arn
  description = "HTTP(80) listener ARN"
}
output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "ALB security group ID"
}

# EFS
output "efs_id" {
  description = "EFS filesystem ID"
  value       = module.efs.file_system_id
}

output "efs_access_points" {
  description = "Map of access point names to IDs"
  value       = module.efs.access_point_ids_by_name
}

output "efs_sg_id" {
  description = "EFS security group ID"
  value       = module.efs.security_group_id
}

# VPC Endpoints
output "vpc_endpoint_ids" {
  description = "IDs of VPC endpoints"
  value       = module.vpc_endpoints.endpoint_ids
}

# VPC/Subnets/Region
output "vpc_id" {
  value = var.vpc_id
}
output "private_subnet_ids" {
  value = var.private_subnet_ids
}
output "public_subnet_ids" {
  value = var.public_subnet_ids
}
output "region" {
  value = var.region
}
