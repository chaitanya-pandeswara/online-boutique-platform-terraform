# Backend configuration for saving and locking tfstate file
terraform {
  
  backend "s3" {
    bucket         = "terra-s3-state-lock"
    key            = "platform/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = false
    dynamodb_table = "terra-ddb-state-lock"
  }
}