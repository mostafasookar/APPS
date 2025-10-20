locals {
  jobs = yamldecode(file("${path.cwd}/../jobs.yaml"))
}

# Upload each job script to S3
resource "aws_s3_object" "scripts" {
  for_each = { for j in local.jobs : j.name => j }

  bucket = "glue-sokar-test"   # ✅ hardcoded bucket name
  key    = "scripts/${each.key}.py"

  source = "${path.cwd}/../${each.value.script_file}"
  etag   = filemd5("${path.cwd}/../${each.value.script_file}")
}

# Create Glue job for each entry
module "glue_jobs" {
  for_each = { for j in local.jobs : j.name => j }
  source   = "../glue-job"

  job_name          = each.value.name
  script_location   = "s3://glue-sokar-test/scripts/${each.key}.py"  
  worker_type       = each.value.worker_type
  number_of_workers = each.value.number_of_workers
  role_arn          = var.role_arn
  glue_version      = var.glue_version
  python_version    = var.python_version
  command_name      = var.command_name
  default_arguments = var.default_arguments
  tags              = var.tags
}
