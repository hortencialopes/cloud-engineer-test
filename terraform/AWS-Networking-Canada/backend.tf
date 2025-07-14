/*
Store the terraform state in s3 bucket and the lock with DynamoDB table
*/

terraform {
  backend "s3" {
    bucket         = "178173414584-ca-central-1"
    key            = "aws-networking/terraform.tfstate"
    region         = "ca-central-1"
    profile        = "terraform-profile"
    dynamodb_table = "178173414584-ca-central-1-terraform-locks"
    encrypt = true
  }
}