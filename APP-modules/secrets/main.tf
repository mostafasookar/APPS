#############################
# Secrets for pgAdmin Login #
#############################

# Always create a random suffix
resource "random_string" "suffix" {
  length  = 5
  special = false
}

resource "aws_secretsmanager_secret" "pgadmin" {
  # For prod/uat → fixed name
  # For test → you can pass a flag later, but by default just use suffix
  name        = "${var.name}-credentials-${random_string.suffix.result}"
  description = "Credentials for pgAdmin default login"
  tags        = merge(local.common_tags, { Name = "${var.name}-secrets" })
}

resource "aws_secretsmanager_secret_version" "pgadmin" {
  secret_id     = aws_secretsmanager_secret.pgadmin.id
  secret_string = jsonencode({
    PGADMIN_DEFAULT_EMAIL    = var.pgadmin_email
    PGADMIN_DEFAULT_PASSWORD = var.pgadmin_password
  })
}
