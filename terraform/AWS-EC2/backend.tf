terraform {
  backend "s3" {
    bucket         = "178173414584-us-east-1"
    key            = "aws-ec2/terraform.tfstate"
    region         = "us-east-1"
    profile        = "terraform-profile"
    dynamodb_table = "ec2-terraform-locks"
    encrypt = true
  }
}