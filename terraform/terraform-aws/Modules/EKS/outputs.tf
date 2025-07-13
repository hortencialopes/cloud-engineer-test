output "cluster_arn" {
  description = "The arn of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_id" {
  description = "The id/name of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API server."
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "The certificate authority data for the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.ecr.repository_url
}

output "codebuild_project_name" {
  description = "The name of the CodeBuild project."
  value       = aws_codebuild_project.app.name
}

