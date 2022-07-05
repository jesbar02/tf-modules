data "aws_iam_policy_document" "ecs-task" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task-role" {
  name               = substr("${var.project}-${var.service_name}-${terraform.workspace}-ecs-task-role", 0, 63)
  assume_role_policy = data.aws_iam_policy_document.ecs-task.json
}

data "aws_iam_policy_document" "secrets-manager-task-policy" {
  count = length(var.secrets_manager) == 2 ? 1 : 0
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      var.secrets_manager[1]
    ]
  }
}

variable "secrets_manager" {
  default = []
}

resource "aws_iam_role_policy" "secrets-manager-ecs-task" {
  count  = length(var.secrets_manager) == 2 ? 1 : 0
  name   = "${var.project}-${var.service_name}-${terraform.workspace}-secretsmanager-ecs-task-policy"
  role   = aws_iam_role.task-role.id
  policy = data.aws_iam_policy_document.secrets-manager-task-policy[0].json
}

data "aws_iam_policy_document" "sns-task-policy" {
  count = var.sns_arn != "" ? 1 : 0
  statement {
    actions = [
      "sns:Publish"
    ]

    resources = var.sns_arn
  }
}

variable "sns_arn" {
  default = []
}

resource "aws_iam_role_policy" "sns-ecs-task" {
  count  = length(var.sns_arn) > 0 ? 1 : 0
  name   = "${var.project}-${var.service_name}-${terraform.workspace}-sns-ecs-task-policy"
  role   = aws_iam_role.task-role.id
  policy = data.aws_iam_policy_document.sns-task-policy[0].json
}

data "aws_iam_policy_document" "bucket" {
  count = length(var.bucket_names) > 0 ? length(var.bucket_names) : 0
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_names[count.index]}"
    ]
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_names[count.index]}/*"
    ]
  }
}

resource "aws_iam_role_policy" "bucket" {
  count  = length(var.bucket_names) > 0 ? length(var.bucket_names) : 0
  name   = "${var.project}-${var.service_name}-${terraform.workspace}-ecs-task-s3-${count.index}-policy"
  role   = aws_iam_role.task-role.id
  policy = data.aws_iam_policy_document.bucket[count.index].json
  lifecycle {
    create_before_destroy = true
  }
}

variable "bucket_names" {
  default = []
}

# SQS

data "aws_iam_policy_document" "sqs-task-policy" {
  count = length(var.sqs_queues) > 0 ? 1 : 0
  statement {
    actions = [
      "sqs:*"
    ]

    resources = var.sqs_queues
  }
}

variable "sqs_queues" {
  default = []
}

resource "aws_iam_role_policy" "sqs-ecs-task" {
  count  = length(var.sqs_queues) > 0 ? 1 : 0
  name   = "${var.project}-${var.service_name}-${terraform.workspace}-sqs-ecs-task-policy"
  role   = aws_iam_role.task-role.id
  policy = data.aws_iam_policy_document.sqs-task-policy[0].json
}

# SES

data "aws_iam_policy_document" "ses-task-policy" {
  count = length(var.ses_from_addresses) > 0 ? 1 : 0
  statement {
    actions = [
      "ses:SendRawEmail",
      "ses:SendEmail"
    ]

    resources = [
      "*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ses:FromAddress"
      values   = var.ses_from_addresses
    }
  }
}

variable "ses_from_addresses" {
  default = []
}

resource "aws_iam_role_policy" "ses-ecs-task" {
  count  = length(var.ses_from_addresses) > 0 ? 1 : 0
  name   = "${var.project}-${var.service_name}-${terraform.workspace}-ses-ecs-task-policy"
  role   = aws_iam_role.task-role.id
  policy = data.aws_iam_policy_document.ses-task-policy[0].json
}
