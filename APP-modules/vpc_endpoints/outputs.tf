output "security_group_id" {
  description = "Security group ID attached to interface endpoints"
  value       = local.vpce_sg_id
}

output "endpoint_ids" {
  description = "IDs of created endpoints"
  value = {
    ecr_api      = aws_vpc_endpoint.ecr_api.id
    ecr_dkr      = aws_vpc_endpoint.ecr_dkr.id
    logs         = aws_vpc_endpoint.logs.id
    secrets      = aws_vpc_endpoint.secretsmanager.id
    ssm          = aws_vpc_endpoint.ssm.id
    ssmmessages  = aws_vpc_endpoint.ssmmessages.id
    ec2messages  = aws_vpc_endpoint.ec2messages.id
    s3_gateway   = length(aws_vpc_endpoint.s3) > 0 ? aws_vpc_endpoint.s3[0].id : null
  }
}
