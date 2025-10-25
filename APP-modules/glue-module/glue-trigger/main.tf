#########################################
# Glue Triggers
#########################################

resource "aws_glue_trigger" "this" {
  for_each = {
    for job in var.jobs :
    job.name => job if try(job.trigger.enabled, false)
  }

  name     = "trigger-${each.key}"
  type     = each.value.trigger.type
  schedule = try(each.value.trigger.schedule, null)

  actions {
    job_name = each.value.name
  }

  tags = var.tags

  depends_on = [var.dependency_modules]
}
