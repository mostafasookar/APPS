output "job_names" {
  description = "List of Glue job names"
  value       = [for j in module.glue_jobs : j.job_name]
}

output "job_arns" {
  description = "List of Glue job ARNs"
  value       = [for j in module.glue_jobs : j.job_arn]
}
