# data "aws_iam_policy_document" "prod_user" {
#   statement {
#     actions = [
#       "iam:GetAccountPasswordPolicy"
#     ]
#     resources = [
#       "*"
#     ]
#   }
# 
#   statement {
#     actions = [
#       "iam:ChangePassword"
#     ]
#     resources = [
#       "arn:aws:iam::*:user/&{aws:username}"
#     ]
#   }
# 
#   statement {
#     actions = [
#       "secretsmanager:DescribeSecret",
#       "secretsmanager:GetSecretValue",
#       "secretsmanager:PutSecretValue"
#     ]
#     resources = var.prod_secret_arns
#   }
# 
#   statement {
#     actions = [
#       "secretsmanager:ListSecrets"
#     ]
#     resources = [
#       "*"
#     ]
#   }
# 
#   statement {
#     actions = [
#       "logs:Get*",
#       "logs:StartQuery",
#       "logs:StopQuery",
#       "logs:TestMetricFilter",
#       "logs:FilterLogEvents"
#     ]
#     resources = [
#       "arn:aws:logs:*:*:log-group:${var.project}-staging:*",
#       "arn:aws:logs:*:*:log-group:${var.project}-production:*"
#     ]
#   }
# 
#   statement {
#     actions = [
#       "logs:List*",
#       "logs:Describe*"
#     ]
#     resources = [
#       "*"
#     ]
#   }
# 
#   statement {
#     actions = [
#       "ssm:StartSession",
#       "ssm:SendCommand"
#     ]
#     resources = [
#       "arn:aws:ec2:*:*:instance/*"
#     ]
#     condition {
#       test     = "StringLike"
#       variable = "ssm:resourceTag/project"
#       values   = [var.project]
#     }
#     condition {
#       test     = "StringLike"
#       variable = "ssm:resourceTag/environment"
#       values   = ["staging", "production"]
#     }
#   }
# 
#   statement {
#     actions = [
#       "ssm:DescribeSessions",
#       "ssm:GetConnectionStatus",
#       "ssm:DescribeInstanceInformation",
#       "ssm:DescribeInstanceProperties",
#       "ec2:DescribeInstances"
#     ]
#     resources = [
#       "*"
#     ]
#   }
# 
#   statement {
#     actions = [
#       "ssm:CreateDocument",
#       "ssm:UpdateDocument",
#       "ssm:GetDocument"
#     ]
#     resources = [
#       "arn:aws:ssm:*:*:document/SSM-SessionManagerRunShell"
#     ]
#   }
# 
#   statement {
#     actions = [
#       "ssm:TerminateSession"
#     ]
#     resources = [
#       "arn:aws:ssm:*:*:session/&{aws:username}-*"
#     ]
#   }
# }
# 
# resource "aws_iam_user" "iam_prod_user" {
#   count = var.create ? length(var.prod_dev_users) : 0
#   name  = "${replace(var.prod_dev_users[count.index], " ", "-")}-${var.project}-production"
# }
# 
# resource "aws_iam_group" "prod_developers" {
#   name = "${var.project}-prod-developers"
#   path = "/users/"
# }
# 
# resource "aws_iam_group_policy" "prod_developer_policy" {
#   name  = "${var.project}-prod-developer-policy"
#   group = aws_iam_group.prod_developers.id
# 
#   policy = data.aws_iam_policy_document.prod_user.json
# }
# 
# resource "aws_iam_user_group_membership" "prod_members" {
#   count = var.create ? length(var.prod_dev_users) : 0
#   user  = "${replace(var.prod_dev_users[count.index], " ", "-")}-${var.project}-production"
# 
#   groups = [
#     aws_iam_group.prod_developers.name
#   ]
# 
#   depends_on = [aws_iam_user.iam_prod_user]
# }
# 
