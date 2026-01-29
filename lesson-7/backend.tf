terraform {
  backend "s3" {
    bucket         = "dmjuke-goit-tf-state-lesson7-2026"
    key            = "lesson-7/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-lesson7"
    encrypt        = true
  }
}