/*

*/

provider "aws" {
  region  = var.region
  profile = "terraform-profile"
}

module "networking" {
  source                  = "../modules/networking"
  region                  = var.region
  project_name            = var.project_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_az1_cidr  = var.public_subnet_az1_cidr
  public_subnet_az2_cidr  = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
  cluster_name = var.cluster_name
}

output "networking_output" {
  value = module.networking
}
