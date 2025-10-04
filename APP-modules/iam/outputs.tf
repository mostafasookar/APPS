output "execution_role_arn" {
  value       = aws_iam_role.execution_role.arn
  description = "ECS Execution Role ARN"
}

output "task_role_arn" {
  value       = aws_iam_role.task_role.arn
  description = "ECS Task Role ARN"
}

output "codedeploy_service_role_arn" {
  value       = aws_iam_role.codedeploy_service_role.arn
  description = "CodeDeploy Service Role ARN"
}
