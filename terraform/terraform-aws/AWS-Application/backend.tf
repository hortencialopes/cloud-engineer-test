/*
Store the terraform state in s3 bucket and the lock with DynamoDB table
*/

terraform {
  backend "s3" {
    bucket         = "simetrik-terraform-tfstate"
    key            = "simetrik-terraform-tfstate/aws-application/terraform.tfstate"
    region         = "sa-east-1"
    profile        = "terraform-profile"
    dynamodb_table = "simetrik-terraform-locks"
  }
}