resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  # count                     = length(var.project) > 0 ? length(var.project) : 0
  alarm_name                = "${var.project}-RDS-FreeStorageSpace"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = 10737418240
  treat_missing_data        = "missing"
  insufficient_data_actions = [var.alarm_topic_arn]
  alarm_actions             = [var.alarm_topic_arn]
  ok_actions                = [var.alarm_topic_arn]

  dimensions = {
    DBInstanceIdentifier      = "${var.project}"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_utilization" {
  # count                     = length(var.project) > 0 ? length(var.project) : 0
  alarm_name                = "${var.project}-RDS-CPUUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = 90
  treat_missing_data        = "missing"
  insufficient_data_actions = [var.alarm_topic_arn]
  alarm_actions             = [var.alarm_topic_arn]
  ok_actions                = [var.alarm_topic_arn]

  dimensions = {
    DBInstanceIdentifier      = "${var.project}"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_db_connections" {
  # count                     = length(var.project) > 0 ? length(var.project) : 0
  alarm_name                = "${var.project}-RDS-DatabaseConnections"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "DatabaseConnections"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = var.connections_threshold
  treat_missing_data        = "missing"
  insufficient_data_actions = [var.alarm_topic_arn]
  alarm_actions             = [var.alarm_topic_arn]
  ok_actions                = [var.alarm_topic_arn]

  dimensions = {
    DBInstanceIdentifier      = "${var.project}"
  }
}
