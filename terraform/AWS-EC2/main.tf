provider "aws" {
  region  = var.region
  profile = "terraform-profile"
}

module "ec2" {
  source                     = "../modules/ec2"
  region                     = var.region
  project_name               = var.project_name
  remote_state_bucket        = var.remote_state_bucket
  remote_state_key           = var.remote_state_key
  remote_state_region        = var.remote_state_region
  key_name                   = var.key_name
}

