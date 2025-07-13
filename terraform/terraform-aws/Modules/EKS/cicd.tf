/*
Building our code build
*/

resource "aws_codebuild_project" "app" {
  name          = "${var.project_name}-${var.cluster_name}-app-build"
  description   = "Builds the application's Docker image and pushes to ECR"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild.arn

  source {
    type     = "CODECOMMIT"
    location = var.codecommit_repo_clone_url_http
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    #priviledgemode is required for building docker images
    privileged_mode = true

    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.app[var.ecr_repository_names[0]].repository_url
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  tags = var.tags

}