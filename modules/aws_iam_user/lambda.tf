# resource "aws_iam_role" "lambda" {
#   count              = var.webhook_url != "" ? 1 : 0
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }
# 
# resource "aws_lambda_function" "lambda" {
#   count         = var.webhook_url != "" ? 1 : 0
#   filename      = "${path.module}/lambda_function_payload.zip"
#   function_name = "${var.project}-${terraform.workspace}-deployment-notification-process"
#   role          = aws_iam_role.lambda[0].arn
#   handler       = "lambda_function.lambda_handler"
#   timeout       = var.deployment_process_lambda_timeout
# 
#   runtime = "ruby2.7"
# 
#   source_code_hash = filebase64sha256("${path.module}/lambda_function_payload.zip")
# 
#   depends_on = [aws_iam_role_policy.lambda, aws_cloudwatch_log_group.lambda]
# 
#   environment {
#     variables = {
#       WEBHOOK_URL = "${var.webhook_url}"
#     }
#   }
# }
# 
# resource "aws_cloudwatch_log_group" "lambda" {
#   count             = var.webhook_url != "" ? 1 : 0
#   name              = "/aws/lambda/${var.project}-${terraform.workspace}-deployment-notification-process"
#   retention_in_days = var.deployment_process_logs_retantion_days
# }
# 
# data "aws_iam_policy_document" "lambda" {
#   count = var.webhook_url != "" ? 1 : 0
#   statement {
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents"
#     ]
# 
#     resources = [
#       aws_cloudwatch_log_group.lambda[0].arn
#     ]
#   }
# 
#   statement {
#     actions = [
#       "ecs:ListClusters",
#       "ecs:ListServices",
#       "ecs:ListTasks",
#       "ecs:DescribeTasks",
#       "ecs:DescribeTaskDefinition"
#     ]
# 
#     resources = [
#       "*"
#     ]
#   }
# }
# 
# resource "aws_iam_role_policy" "lambda" {
#   count  = var.webhook_url != "" ? 1 : 0
#   name   = "${var.project}-${terraform.workspace}-deployment-notification-process-lambda"
#   role   = aws_iam_role.lambda[0].id
#   policy = data.aws_iam_policy_document.lambda[0].json
# }
