resource "aws_cloudwatch_metric_alarm" "edge_scheduler_worker" {
  alarm_name          = "${var.project}-edge-scheduler-${terraform.workspace}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  treat_missing_data  = "breaching"
  alarm_actions       = [var.alarm_topic_arn]
  ok_actions          = [var.alarm_topic_arn]

  dimensions = {
    "ServiceName" = "edge-resque-scheduler-worker-staging",
    "ClusterName" = "workers"
    }

}

resource "aws_cloudwatch_metric_alarm" "patient_self_report_scheduler_worker" {
  alarm_name          = "${var.project}-patient-self-report-scheduler-${terraform.workspace}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  treat_missing_data  = "breaching"
  alarm_actions       = [var.alarm_topic_arn]
  ok_actions          = [var.alarm_topic_arn]

  dimensions = {
    "ServiceName" = "patient-self-report-scheduler-worker-staging",
    "ClusterName" = "workers"
    }

}

resource "aws_cloudwatch_metric_alarm" "provider_portal_scheduler_worker" {
  alarm_name          = "${var.project}-provider-portal-scheduler-${terraform.workspace}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  treat_missing_data  = "breaching"
  alarm_actions       = [var.alarm_topic_arn]
  ok_actions          = [var.alarm_topic_arn]

  dimensions = {
    "ServiceName" = "provider-portal-scheduler-worker-staging",
    "ClusterName" = "workers"
    }

}

resource "aws_cloudwatch_metric_alarm" "marketplace_rq_scheduler_worker" {
  alarm_name          = "${var.project}-marketplace-rq-scheduler-${terraform.workspace}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  treat_missing_data  = "breaching"
  alarm_actions       = [var.alarm_topic_arn]
  ok_actions          = [var.alarm_topic_arn]

  dimensions = {
    "ServiceName" = "marketplace-rq-scheduler-worker-staging",
    "ClusterName" = "workers"
    }

}
