resource "aws_cloudwatch_metric_alarm" "this" {
  count                     = var.alb_suffix != "" && var.alarm_topic_arn != "" ? 1 : 0
  alarm_name                = "${var.project}-${var.service_name}-${terraform.workspace}"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "HealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "0"
  treat_missing_data        = "breaching"
  insufficient_data_actions = [var.alarm_topic_arn]
  alarm_actions             = [var.alarm_topic_arn]
  ok_actions                = [var.alarm_topic_arn]

  dimensions = {
    TargetGroup  = aws_alb_target_group.this.arn_suffix
    LoadBalancer = var.alb_suffix
  }
}
