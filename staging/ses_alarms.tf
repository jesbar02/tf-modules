resource "aws_cloudwatch_metric_alarm" "ses_complaint_rate" {
  alarm_name                = "${var.project}-${terraform.workspace}-SES-ComplaintRate"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Reputation.ComplaintRate"
  namespace                 = "AWS/SES"
  period                    = "3600"
  statistic                 = "Average"
  threshold                 = "0.1"
  treat_missing_data        = "missing"
  alarm_actions             = [var.alarm_topic_arn]
  ok_actions                = [var.alarm_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "ses_bounce_rate" {
  alarm_name                = "${var.project}-${terraform.workspace}-SES-BounceRate"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "Reputation.BounceRate"
  namespace                 = "AWS/SES"
  period                    = "3600"
  statistic                 = "Average"
  threshold                 = 5
  treat_missing_data        = "missing"
  alarm_actions             = [var.alarm_topic_arn]
  ok_actions                = [var.alarm_topic_arn]
}
