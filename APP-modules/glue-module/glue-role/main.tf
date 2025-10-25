#########################################
# IAM Role for AWS Glue
#########################################

resource "aws_iam_role" "glue_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

#########################################
# Managed Policy Attachments
#########################################

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
