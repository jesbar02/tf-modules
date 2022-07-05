module "rds_alarm" {
  source                = "../modules//aws_rds_alarms/"
  project               = "${var.project}-${terraform.workspace}"
  alarm_topic_arn       = var.alarm_topic_arn
  connections_threshold = 80
}

module "rds_read_replica_alarm" {
  source                = "../modules//aws_rds_alarms/"
  project               = "${var.project}-${terraform.workspace}-read-replica"
  alarm_topic_arn       = var.alarm_topic_arn
  connections_threshold = 80
}
