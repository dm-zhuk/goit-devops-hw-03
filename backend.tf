/*
terraform {
  backend "s3" {
    bucket         = "dm-zhuk-tf-state-27"
    key            = "dev/final-project/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
*/