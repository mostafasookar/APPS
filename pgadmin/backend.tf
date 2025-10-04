terraform {
  backend "s3" {
    bucket         = "pgadmin-terraform-state-test"
    key            = "pgadmin/terraform.tfstate" # pgadmin app state
    region         = "us-east-1"
    dynamodb_table = "pgadmin-terraform-locks" # same table for locks
    encrypt        = true
  }
}
