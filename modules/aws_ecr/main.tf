resource "aws_ecr_repository" "this" {
  count = var.create ? 1 : 0
  name  = "${var.project}-${terraform.workspace}"

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}

data "template_file" "this" {
  count    = var.create ? 1 : 0
  template = file("${path.module}/policies.json")

  vars = {
    image_count  = var.tagged_image_count
    day_count    = var.untagged_day_count
    tag_prefixes = jsonencode(var.tag_prefixes)
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.create ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = data.template_file.this[0].rendered
}

resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  count      = var.create ? 1 : 0
  repository = aws_ecr_repository.this[0].name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CodeBuildAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    }
  ]
}
EOF
}
