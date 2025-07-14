/*
Building our code build
*/

resource "aws_codebuild_project" "app" {
  name          = "${var.project_name}-${var.cluster_name}-app-build"
  description   = "Builds the application's Docker image and pushes to ECR"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild.arn

  # source {
  #   type     = "CODECOMMIT"
  #   location = var.codecommit_repo_clone_url_http
  # }

  source {
    type      = var.code_build_source_type
    location  = var.code_build_source_repo_url
    buildspec = "buildspec.yml"
    # Optional: Configure Git submodules and source version
    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = var.code_build_source_version

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    #priviledgemode is required for building docker images
    privileged_mode = true

    environment_variable {
      name  = "CLUSTER_NAME"
      value = var.cluster_name
    }

    environment_variable {
      name  = "REPOSITORY_URL"
      value = aws_ecr_repository.ecr.repository_url
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


##Tried retrieving the secret but got tons of permissions error even changin the policies
# data "aws_secretsmanager_secret_version" "github" {
#   secret_id = "arn:aws:secretsmanager:sa-east-1:178173414584:secret:github-qpHOO6"
# }

resource "aws_codebuild_source_credential" "github" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.git_hub_token
}


/**
https://docs.aws.amazon.com/codebuild/latest/userguide/github-webhook.html
*/
resource "aws_codebuild_webhook" "github_trigger" {
  project_name = aws_codebuild_project.app.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "refs/heads/main"
    }
  }
}