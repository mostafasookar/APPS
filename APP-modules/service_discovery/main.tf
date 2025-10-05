############################
# Service Discovery (Cloud Map)
############################

# Private DNS namespace in your VPC (no Route 53 hosted zone required)
resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = var.namespace_name
  description = "Private namespace for ${var.namespace_name}"
  vpc         = var.vpc_id
  tags        = var.tags
}

# DB service entry, will resolve as: <db_service_name>.<namespace_name>
# Using A records so ECS registers the task ENI IPs.
resource "aws_service_discovery_service" "db" {
  name = var.db_service_name

  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.this.id
    routing_policy = "MULTIVALUE"

    dns_records {
      type = "A"
      ttl  = 5
    }
  }

  # For ECS-managed health. Keep the block; the failure_threshold arg is deprecated and omitted.
  health_check_custom_config {}

  tags = var.tags
}

# OPTIONAL: API service entry (created only when api_service_name != "")
resource "aws_service_discovery_service" "api" {
  count = var.api_service_name == "" ? 0 : 1
  name  = var.api_service_name

  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.this.id
    routing_policy = "MULTIVALUE"

    dns_records {
      type = "A"
      ttl  = 5
    }
  }

  health_check_custom_config {}

  tags = var.tags
}
