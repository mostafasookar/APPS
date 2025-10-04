output "pgadmin_secret_arn" {
  description = "ARN of the pgAdmin secret"
  value       = aws_secretsmanager_secret.pgadmin.arn
}
