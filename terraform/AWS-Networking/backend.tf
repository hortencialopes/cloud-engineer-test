/*
Store the terraform state in s3 bucket and the lock with DynamoDB table
*/

# #cluster 
terraform {
  backend "s3" {
    bucket         = "178173414584-us-east-1"
    key            = "aws-networking/terraform.tfstate"
    region         = "us-east-1"
    profile        = "terraform-profile"
    dynamodb_table = "178173414584-us-east-1-terraform-locks"
    encrypt = true
  }
}


