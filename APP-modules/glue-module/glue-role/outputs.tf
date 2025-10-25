output "glue_role_name" {
  description = "IAM role name"
  value       = aws_iam_role.glue_role.name
}

output "glue_role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.glue_role.arn
}

output "glue_role_tags" {
  description = "Default organizational tags for use in other modules"
  value       = var.tags
}
