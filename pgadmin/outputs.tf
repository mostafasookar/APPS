output "pgadmin_alb_dns" {
  description = "ALB DNS name for pgAdmin"
  value       = data.terraform_remote_state.infra.outputs.alb_dns_name
}

output "pgadmin_service_name" {
  description = "ECS service name for pgAdmin"
  value       = aws_ecs_service.app.name
}

output "pgadmin_url" {
  description = "Open pgAdmin in browser"
  value       = "http://${data.terraform_remote_state.infra.outputs.alb_dns_name}/"
}
