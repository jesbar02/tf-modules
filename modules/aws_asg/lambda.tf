resource "aws_iam_role" "lambda" {
  count = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name  = "${var.project}-${terraform.workspace}-${var.cluster_names[count.index]}-draining-process-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  count         = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  filename      = "${path.module}/lambda_function_payload.zip"
  function_name = "${var.project}-${terraform.workspace}-${var.cluster_names[count.index]}-draining-process"
  role          = aws_iam_role.lambda[count.index].arn
  handler       = "lambda_function.lambda_handler"
  timeout       = var.draining_process_lambda_timeout

  runtime = "ruby2.7"

  source_code_hash = filebase64sha256("${path.module}/lambda_function_payload.zip")

  depends_on = [aws_iam_role_policy.lambda, aws_cloudwatch_log_group.lambda]

  environment {
    variables = {
      CLUSTER_NAME = var.cluster_names[count.index]
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  count             = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name              = "${var.project}-${terraform.workspace}-${var.cluster_names[count.index]}-draining-process"
  retention_in_days = var.draining_process_logs_retantion_days
}

data "aws_iam_policy_document" "lambda" {
  count = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.lambda[count.index].arn
    ]
  }

  statement {
    actions = [
      "autoscaling:CompleteLifecycleAction"
    ]

    resources = [aws_autoscaling_group.this[count.index].arn]
  }

  statement {
    actions = [
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
      "ecs:UpdateContainerInstancesState"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda" {
  count  = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name   = "${var.project}-${terraform.workspace}-${var.cluster_names[count.index]}-draining-process-lambda"
  role   = aws_iam_role.lambda[count.index].id
  policy = data.aws_iam_policy_document.lambda[count.index].json
}
