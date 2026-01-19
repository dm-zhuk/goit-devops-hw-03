/*
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-2026"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
*/