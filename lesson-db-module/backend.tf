/*
terraform {
  backend "s3" {
    bucket         = "dmzhuk-tf-state-rds" # Change this to your bucket name
    key            = "dev/lesson-db-module/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
*/