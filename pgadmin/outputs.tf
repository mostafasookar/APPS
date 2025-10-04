output "pgadmin_alb_dns" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the pgAdmin ALB"
}

output "pgadmin_service_name" {
  value       = module.ecs.ecs_service_name
  description = "Name of ECS service for pgAdmin"
}
