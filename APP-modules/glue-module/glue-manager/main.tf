#########################################
# Glue Manager
# Uploads scripts and creates jobs
#########################################

# Upload job scripts to S3
resource "aws_s3_object" "scripts" {
  for_each = { for job in var.jobs : job.name => job }

  bucket = var.scripts_bucket
  key    = "scripts/${each.key}.py"
  source = "${var.scripts_root}/${each.value.script_file}"
  etag   = filemd5("${var.scripts_root}/${each.value.script_file}")

  tags = var.tags
}

# Create Glue Jobs
module "glue_jobs" {
  for_each = { for job in var.jobs : job.name => job }
  source   = "../glue-job"

  job_name          = each.value.name
  description       = try(each.value.description, "")
  role_arn          = var.role_arn
  script_location   = "s3://${var.scripts_bucket}/scripts/${each.key}.py"
  glue_version      = try(each.value.glue_version, "5.0")
  python_version    = try(each.value.python_version, "3")
  command_name      = try(each.value.command_name, "glueetl")
  worker_type       = try(each.value.worker_type, "G.2X")
  number_of_workers = try(each.value.number_of_workers, 2)
  timeout           = try(each.value.timeout, 300)
  max_retries       = try(each.value.max_retries, 0)
  connections       = try(each.value.connections, [])
  default_arguments = try(each.value.default_arguments, {})
  tags              = merge(var.tags, lookup(each.value, "tags", {}))
}
