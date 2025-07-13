variable "project_name" {
  type        = string
  description = "The name of the project, used for naming resources."
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
  default     = "primary-cluster"
}