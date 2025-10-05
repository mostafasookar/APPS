output "namespace_id" {
  description = "Cloud Map namespace ID"
  value       = aws_service_discovery_private_dns_namespace.this.id
}

output "namespace_name" {
  description = "Cloud Map namespace name"
  value       = aws_service_discovery_private_dns_namespace.this.name
}

output "db_service_id" {
  description = "ID of the DB service entry"
  value       = aws_service_discovery_service.db.id
}

output "db_service_arn" {
  description = "ARN of the DB service entry"
  value       = aws_service_discovery_service.db.arn
}

output "api_service_id" {
  description = "ID of the API service entry (null if not created)"
  value       = try(aws_service_discovery_service.api[0].id, null)
}

output "api_service_arn" {
  description = "ARN of the API service entry (null if not created)"
  value       = try(aws_service_discovery_service.api[0].arn, null)
}
