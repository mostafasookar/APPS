output "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "cpu_alarm_arn" {
  description = "CloudWatch alarm ARN for high CPU"
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
}

output "memory_alarm_arn" {
  description = "CloudWatch alarm ARN for high Memory"
  value       = aws_cloudwatch_metric_alarm.memory_high.arn
}
