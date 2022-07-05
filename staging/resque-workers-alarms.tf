resource "aws_cloudwatch_metric_alarm" "therapist_signup_resque_worker" {
  alarm_name          = "${var.project}-therapist-signup-resque-${terraform.workspace}"
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
    "ServiceName" = "therapist-signup-resque-worker-staging",
    "ClusterName" = "workers"
    }

}

resource "aws_cloudwatch_metric_alarm" "edge_resque_worker" {
  alarm_name          = "${var.project}-edge-resque-${terraform.workspace}"
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
    "ServiceName" = "edge-resque-worker-staging",
    "ClusterName" = "workers"
    }

}

resource "aws_cloudwatch_metric_alarm" "patient_self_report_resque_worker" {
  alarm_name          = "${var.project}-patient-self-report-resque-${terraform.workspace}"
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
    "ServiceName" = "patient-self-report-resque-worker-staging",
    "ClusterName" = "workers"
    }

}

resource "aws_cloudwatch_metric_alarm" "provider_portal_resque_worker" {
  alarm_name          = "${var.project}-provider-portal-resque-${terraform.workspace}"
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
    "ServiceName" = "provider-portal-resque-worker-staging",
    "ClusterName" = "workers"
    }

}

resource "aws_cloudwatch_metric_alarm" "marketplace_rq_resque_worker" {
  alarm_name          = "${var.project}-marketplace-rq-resque-${terraform.workspace}"
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
    "ServiceName" = "marketplace-rq-echo-worker-staging",
    "ClusterName" = "workers"
    }

}
