provider "aws" {
  region  = var.region
  profile = "terraform-profile"
}

module "eks" {
  source                     = "../modules/eks"
  region                     = var.region
  project_name               = var.project_name
  remote_state_bucket        = var.remote_state_bucket
  remote_state_key           = var.remote_state_key
  remote_state_region        = var.remote_state_region
  code_build_source_type     = var.code_build_source_type
  code_build_source_repo_url = var.code_build_source_repo_url
  code_build_source_version  = var.code_build_source_version
  cluster_name               = var.cluster_name
  git_hub_token              = var.git_hub_token
  admin_user_arns            = [var.admin_user_arn]
}

output "eks_output" {
  value = module.eks
}

