output "file_system_id" {
  description = "EFS filesystem ID"
  value       = aws_efs_file_system.this.id
}

output "security_group_id" {
  description = "Security group ID used for EFS mount targets (if created)"
  value       = local.efs_sg_id
}

output "access_point_ids_by_name" {
  description = "Map of access point name to ID"
  value       = { for k, v in aws_efs_access_point.ap : k => v.id }
}
