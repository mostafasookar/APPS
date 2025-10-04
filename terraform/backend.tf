terraform {
  backend "s3" {
    bucket         = "pgadmin-terraform-state-test"
    key            = "terraform/terraform.tfstate" # shared infra state
    region         = "us-east-1"
    dynamodb_table = "pgadmin-terraform-locks" # keep existing table
    encrypt        = true
  }
}
