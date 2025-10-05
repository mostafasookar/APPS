terraform {
  backend "s3" {
    bucket         = "pgadmin-terraform-state-test"
    key            = "marquez/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pgadmin-terraform-locks"
    encrypt        = true
  }
}
