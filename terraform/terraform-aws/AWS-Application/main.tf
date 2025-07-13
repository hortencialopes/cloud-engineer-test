# /root/main.tf

# Provider for the Virginia region
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# Provider for the Ireland region
provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

# Deploy the EKS module in Virginia
module "eks_us_east_1" {
  source = "./modules/eks"
  providers = {
    aws = aws.us-east-1
  }
  
  # ... other variables for the us-east-1 cluster
  region              = "us-east-1"
  remote_state_bucket = "networking-state-bucket-use1"
  # ...
}

# Deploy the EKS module in Ireland
module "eks_eu_west_1" {
  source = "./modules/eks"
  providers = {
    aws = aws.eu-west-1
  }

  # ... other variables for the eu-west-1 cluster
  region              = "eu-west-1"
  remote_state_bucket = "networking-state-bucket-euw1"
  # ...
}