output "autoscaling_target_id" {
  value       = aws_appautoscaling_target.ecs.resource_id
  description = "Resource ID for ECS autoscaling"
}
