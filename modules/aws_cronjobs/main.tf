data "aws_ecs_cluster" "cluster" {
  cluster_name = "${var.project}-${terraform.workspace}"
}

resource "aws_cloudwatch_event_rule" "event-rule" {
  count               = length(var.cron_expression) > 0 ? length(var.cron_expression) : 0
  name                = "${var.project}-${terraform.workspace}-${var.service_name}-${var.cron_name[count.index]}"
  schedule_expression = "cron(${var.cron_expression[count.index]})"
}

resource "aws_cloudwatch_event_target" "event-target" {
  count     = length(var.cmd) > 0 ? length(var.cmd) : 0
  rule      = aws_cloudwatch_event_rule.event-rule[count.index].name
  target_id = "${var.project}-${terraform.workspace}-${var.service_name}-${var.cron_name[count.index]}"
  role_arn  = var.role_arn
  input     = "{ \"containerOverrides\": [ { \"name\": \"${var.service_name}-${terraform.workspace}\", \"command\": [${var.cmd[count.index]}] } ] }"
  arn       = data.aws_ecs_cluster.cluster.id

  ecs_target {
    task_count          = 1
    task_definition_arn = var.task_definition_arn
  }

}
