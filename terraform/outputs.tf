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

output "vpc_endpoint_ids" {
  description = "IDs of VPC endpoints"
  value       = module.vpc_endpoints.endpoint_ids
}

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
