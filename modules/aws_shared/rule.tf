resource "aws_cloudwatch_event_rule" "rule" {
  count       = var.webhook_url != "" ? 1 : 0
  name        = "${var.project}-${terraform.workspace}-deployment-notification-process"
  description = "Deployment Notification Process"

  event_pattern = <<PATTERN
{
  "detail": {
    "awsRegion": [
      "us-east-1"
    ],
    "eventName": [
      "UpdateService"
    ],
    "eventSource": [
      "ecs.amazonaws.com"
    ],
    "eventType": [
      "AwsApiCall"
    ],
    "userIdentity": {
      "arn": [
        "arn:aws:iam::308471543643:user/circleci-user"
      ],
      "type": [
        "IAMUser"
      ],
      "userName": [
        "circleci-user"
      ]
    }
  },
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "region": [
    "us-east-1"
  ],
  "source": [
    "aws.ecs"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "rule" {
  count     = var.webhook_url != "" ? 1 : 0
  rule      = aws_cloudwatch_event_rule.rule[0].name
  target_id = "DeploymentNotificationProcess"
  arn       = aws_lambda_function.lambda[0].arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = var.webhook_url != "" ? 1 : 0
  statement_id  = "DeploymentNotificationProcess"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule[0].arn
}

