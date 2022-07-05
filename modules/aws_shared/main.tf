data "aws_iam_policy_document" "user" {
  count = var.create ? length(var.ec2_dev_users) : 0
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
      "ssm:StartSession",
      "ssm:SendCommand"
    ]
    resources = [
      "arn:aws:ec2:*:*:instance/*"
    ]
    condition {
      test     = "StringLike"
      variable = "ssm:resourceTag/project"
      values   = [var.project]
    }
    condition {
      test     = "StringLike"
      variable = "ssm:resourceTag/environment"
      values   = [terraform.workspace]
    }
  }

  statement {
    actions = [
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus",
      "ssm:DescribeInstanceInformation",
      "ssm:DescribeInstanceProperties",
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:CreateDocument",
      "ssm:UpdateDocument",
      "ssm:GetDocument"
    ]
    resources = [
      "arn:aws:ssm:*:*:document/SSM-SessionManagerRunShell"
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
}

resource "aws_iam_user" "iam_user" {
  count = var.create ? length(var.ec2_dev_users) : 0
  name  = "${replace(var.ec2_dev_users[count.index], " ", "-")}-${var.project}-${terraform.workspace}"
}

resource "aws_iam_group" "developers" {
  count = var.create ? length(var.ec2_dev_users) : 0
  name  = "${var.project}-${terraform.workspace}-developers"
  path  = "/users/"
}

resource "aws_iam_group_policy" "developer_policy" {
  count = var.create ? length(var.ec2_dev_users) : 0
  name  = "${var.project}-${terraform.workspace}-developer-policy"
  group = aws_iam_group.developers[0].id

  policy = data.aws_iam_policy_document.user[0].json
}

resource "aws_iam_user_group_membership" "members" {
  count = var.create ? length(var.ec2_dev_users) : 0
  user  = "${replace(var.ec2_dev_users[count.index], " ", "-")}-${var.project}-${terraform.workspace}"

  groups = [
    aws_iam_group.developers[0].name
  ]

  depends_on = [aws_iam_user.iam_user]
}

