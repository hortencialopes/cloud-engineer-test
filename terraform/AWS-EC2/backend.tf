terraform {
  backend "s3" {
    bucket         = "insert your bucket name"
    key            = "insert your bucket key"
    region         = "your region"
    profile        = "your cli profile"
    dynamodb_table = "your dynamo db table"
    encrypt = true
  }
}