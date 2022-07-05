data "template_file" "this" {
  template = file("${path.module}/task.json")

  vars = {
    task_name          = "${var.service_name}-${terraform.workspace}"
    docker_image       = var.docker_image
    memory_reservation = var.memory_reservation
    task_role_arn      = aws_iam_role.task-role.arn
    task_exec_role_arn = aws_iam_role.task-exec-role.arn
    log_group          = var.log_group != "" ? var.log_group : "${var.project}-${terraform.workspace}"
    aws_region         = var.aws_region
    log_prefix         = var.log_prefix != "" ? var.log_prefix : var.service_name
    s3_bucket_name     = var.s3_environment_variables[0]
    s3_var_file        = var.s3_environment_variables[1]
    cmd                = var.cmd
    nofile_soft_limit  = var.nofile_soft_limit
    nofile_hard_limit  = var.nofile_hard_limit
  }
}

resource "aws_ecs_task_definition" "this" {
  family                = "${var.project}-${var.service_name}-${terraform.workspace}"
  container_definitions = data.template_file.this.rendered
  task_role_arn         = aws_iam_role.task-role.arn
  execution_role_arn    = aws_iam_role.task-exec-role.arn

  depends_on = [aws_iam_role.task-role, aws_iam_role_policy.ecs-task-exec]
}

resource "aws_ecs_service" "this" {
  name                               = "${var.service_name}-${terraform.workspace}"
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100

  capacity_provider_strategy {
    capacity_provider = split("/", var.cluster_id)[1]
    weight            = var.capacity_provider_weight
    base              = var.capacity_provider_base
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_role_policy.secrets-manager-ecs-task, aws_iam_role_policy.ecs-task-exec]
}
