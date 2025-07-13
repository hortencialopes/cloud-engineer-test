variable "project_name" {
  type        = string
  description = "The name of the project, used for naming resources."
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
  default     = "primary-cluster"
}

variable "ecr_name" {
  type        = string
  description = "The name of the ECR registry."
  default     = null
}

variable "image_mutability" {
  type        = string
  description = "Provide image mutability."
  default     = "IMMUTABLE"
}

variable "encrypt_type" {
  type        = string
  description = "Provide encryption type here."
  default     = "KMS"
}

variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = null
}
