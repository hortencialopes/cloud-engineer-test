/*
Store the terraform state in s3 bucket and the lock with DynamoDB table
*/

# #cluster 1
# terraform {
#   backend "s3" {
#     bucket         = "178173414584-us-east-1"
#     key            = "aws-networking/terraform.tfstate"
#     region         = "us-east-1"
#     profile        = "terraform-profile"
#     dynamodb_table = "178173414584-us-east-1-terraform-locks"
#     encrypt = true
#   }
# }


#cluster 2
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