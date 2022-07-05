resource "aws_cloudwatch_event_rule" "rule" {
  count       = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name        = "${var.project}-${terraform.workspace}-${var.cluster_names[count.index]}-draining-process"
  description = "Draining Process"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance-terminate Lifecycle Action"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${var.cluster_names[count.index]}"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "rule" {
  count     = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  rule      = aws_cloudwatch_event_rule.rule[count.index].name
  target_id = "DrainingProcess"
  arn       = aws_lambda_function.lambda[count.index].arn

  depends_on = [aws_lambda_permission.allow_cloudwatch]
}


resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  statement_id  = "DrainingProcess"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule[count.index].arn

  depends_on = [aws_cloudwatch_event_rule.rule]
}
