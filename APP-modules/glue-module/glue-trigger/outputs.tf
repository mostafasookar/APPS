output "trigger_names" {
  description = "Names of created Glue triggers"
  value       = [for t in aws_glue_trigger.this : t.name]
}
