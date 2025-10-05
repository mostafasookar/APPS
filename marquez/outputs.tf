output "marquez_alb_dns" {
  description = "ALB DNS name for Marquez"
  value       = data.terraform_remote_state.infra.outputs.alb_dns_name
}

output "marquez_service_name" {
  description = "ECS service name for Marquez"
  value       = aws_ecs_service.app.name
}

output "marquez_url" {
  description = "Open Marquez web UI in browser"
  value       = "http://${data.terraform_remote_state.infra.outputs.alb_dns_name}${var.alb_path_prefix}"
}
