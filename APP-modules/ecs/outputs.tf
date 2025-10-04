output "ecs_cluster_id" {
  value       = aws_ecs_cluster.this.id
  description = "ECS cluster ID"
}

output "ecs_service_name" {
  value       = aws_ecs_service.this.name
  description = "ECS service name"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.this.name
  description = "ECS cluster name (used for CodeDeploy)"
}
