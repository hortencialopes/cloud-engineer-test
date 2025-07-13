/*
My data vars
*/

variable "remote_state_bucket" {
  type        = string
  description = "The bucket I need to fetch the networking state from"
}

variable "remote_state_key" {
  type        = string
  description = "The key of the state file"
}

variable "remote_state_region" {
  type        = string
  description = "The region my remote state is"
}

/*
Cluster essentials
*/

variable "project_name" {
  type        = string
  description = "The name of the project, used for naming resources."
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "cluster_version" {
  type        = string
  description = "The Kubernetes version for the EKS cluster."
  default     = "1.30"
}

variable "region" {
  type        = string
  description = "The AWS region where all resources for this module will be created."
}

/*
Node groups vars
*/
variable "node_group_name" {
  type        = string
  description = "The name of the managed node group."
  default     = "primary-workers"
}

variable "node_group_ami_type" {
  type        = string
  description = "The AMI type for the node group."
  default     = "AL2_x86_64" # Aligned with the default t3.medium (x86) instance type.
}

variable "node_group_instance_types" {
  type        = list(string)
  description = "The EC2 instance types for the EKS node group."
  default     = ["t3.medium"]
}

variable "node_group_capacity_type" {
  type        = string
  description = "The capacity type for the node group (e.g., ON_DEMAND, SPOT)."
  default     = "ON_DEMAND"
}

variable "node_group_desired_size" {
  type        = number
  description = "The desired number of worker nodes."
  default     = 2
}

variable "node_group_max_size" {
  type        = number
  description = "The maximum number of worker nodes."
  default     = 3
}

variable "node_group_min_size" {
  type        = number
  description = "The minimum number of worker nodes."
  default     = 1
}


/*
ECR vars
*/


variable "image_tag_mutability" {
  type        = string
  description = "Provide image mutability."
  default     = "IMMUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "The image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "encrypt_type" {
  type        = string
  description = "Provide encryption type here."
  default     = "KMS"
}

/*
CodeBuild vars
*/
variable "code_build_source_type" {
  type        = string
  description = "Which source to fetch the repo from"
  default     = "GITHUB"
}

## repo arn used in iam
variable "code_build_source_repo_url" {
  type        = string
  description = "The url of the repo"
}
variable "code_build_source_version" {
  type        = string
  description = "Which branch to fetch the code"
  default     = "main"
}


/*
General
*/
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}


variable "git_hub_token" {
  description = "The token of the git hub"
  sensitive   = true
}