data "aws_iam_policy_document" "user" {
  count      = length(var.service_name) > 0 ? length(var.service_name) : 0
  statement {
    actions = [
      "iam:GetAccountPasswordPolicy"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:ChangePassword"
    ]
    resources = [
      "arn:aws:iam::*:user/&{aws:username}"
    ]
  }

  statement {
    actions = [
      "logs:Get*",
      "logs:StartQuery",
      "logs:StopQuery",
      "logs:TestMetricFilter",
      "logs:FilterLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:${var.project}-${terraform.workspace}:*"
    ]
  }

  statement {
    actions = [
      "logs:List*",
      "logs:Describe*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:StartSession"
    ]
    resources = [
      "arn:aws:ec2:*:*:instance/*",
      "arn:aws:ssm:*:*:document/SSM-SessionManagerRunShell"
    ]
    condition {
      test     = "BoolIfExists"
      variable = "ssm:SessionDocumentAccessCheck"
      values   = ["true"]
    }
  }

  statement {
    actions = [
      "ssm:StartSession"
    ]
    resources = [
      "arn:aws:ec2:*:*:instance/*",
      "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
    ]
  }

  statement {
    actions = [
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus",
      "ssm:DescribeInstanceProperties",
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:TerminateSession"
    ]
    resources = [
      "arn:aws:ssm:*:*:session/&{aws:username}-*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_environment_variables[0]}"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_environment_variables[0]}/${var.s3_environment_variables[1]}"
    ]
  }

  statement {
    actions = [
      "ecs:ListServices",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "secret" {
  count = length(var.dev_secret_arns) > 0 ? length(var.dev_secret_arns) : 0
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue"
    ]
    resources = var.dev_secret_arns
  }

  statement {
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_group" "developers" {
  name = "${var.project}-${var.service_name}-${terraform.workspace}-developers"
  path = "/users/"
}

resource "aws_iam_group_policy" "developer_policy" {
  count      = length(var.service_name) > 0 ? length(var.service_name) : 0
  name  = "${var.project}-${var.service_name}-${terraform.workspace}-developer-policy"
  group = aws_iam_group.developers.id

  policy = data.aws_iam_policy_document.user[0].json
}

resource "aws_iam_group_policy" "developer_secret_policy" {
  count = length(var.dev_secret_arns) > 0 ? length(var.dev_secret_arns) : 0
  name  = "${var.project}-${var.service_name}-${terraform.workspace}-developer-secret-policy"
  group = aws_iam_group.developers.id

  policy = data.aws_iam_policy_document.secret[0].json
}

data "aws_iam_policy_document" "bucket" {
  count = length(var.dev_bucket_names) > 0 ? length(var.dev_bucket_names) : 0
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.dev_bucket_names[count.index]}"
    ]
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.dev_bucket_names[count.index]}/*"
    ]
  }
}

resource "aws_iam_group_policy" "s3_policy" {
  count = length(var.dev_bucket_names) > 0 ? length(var.dev_bucket_names) : 0
  name  = "${var.project}-${var.service_name}-${terraform.workspace}-s3-${count.index}-policy"
  group = aws_iam_group.developers.id

  policy = data.aws_iam_policy_document.bucket[count.index].json
}

resource "aws_iam_group_policy_attachment" "managed_policy_attachments" {
  count      = length(var.managed_policies) > 0 ? length(var.managed_policies) : 0 
  group      = aws_iam_group.developers.id
  policy_arn = "arn:aws:iam::aws:policy/${var.managed_policies[count.index]}"
}