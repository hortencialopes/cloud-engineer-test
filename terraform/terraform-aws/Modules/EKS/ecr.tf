/* defining the ecr deployment
    heavily based on https://medium.com/@praveenvallepu/amazon-ecr-repository-with-terraform-3e430369900d

*/

resource "aws_ecr_repository" "ecr" {
  for_each         = toset(var.ecr_name)
  name             = each.key
  image_mutability = var.image_mutability
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name
  policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep last 20 images",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 30
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}