/*
terraform {
  backend "s3" {
    bucket         = "dmzhuk-tf-state-rds"
    key            = "dev/final-project/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
*/