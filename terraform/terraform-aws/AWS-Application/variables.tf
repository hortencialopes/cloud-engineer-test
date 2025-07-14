
/*
Where we'll define input variables to use in the reusable EKS module
*/

variable "region" {}
variable "project_name" {}
variable "remote_state_bucket" {}
variable "remote_state_key" {}
variable "remote_state_region" {}
variable "code_build_source_type" {}
variable "code_build_source_repo_url" {}
variable "code_build_source_version" {}
variable "cluster_name" {}
variable "git_hub_token" {}
