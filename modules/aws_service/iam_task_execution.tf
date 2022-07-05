data "aws_iam_policy_document" "ecs-task-exec" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task-exec-role" {
  name               = substr("${var.project}-${var.service_name}-${terraform.workspace}-ecs-task-exec-role", 0, 63)
  assume_role_policy = data.aws_iam_policy_document.ecs-task-exec.json
}

data "aws_iam_policy_document" "task-exec-policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_environment_variables[0]}/${var.s3_environment_variables[1]}"
    ]
  }

  statement {
    actions = [
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_environment_variables[0]}"
    ]
  }
}

resource "aws_iam_role_policy" "ecs-task-exec" {
  name   = "${var.project}-${var.service_name}-${terraform.workspace}-ecs-task-exec-policy"
  role   = aws_iam_role.task-exec-role.id
  policy = data.aws_iam_policy_document.task-exec-policy.json
}
