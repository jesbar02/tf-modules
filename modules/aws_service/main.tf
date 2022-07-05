data "template_file" "this" {
  template = file("${path.module}/task.json")

  vars = {
    secret_id          = length(var.secrets_manager) == 2 ? var.secrets_manager[0] : "${var.project}-${var.service_name}-${terraform.workspace}"
    task_name          = "${var.service_name}-${terraform.workspace}"
    docker_image       = var.docker_image
    memory_reservation = var.memory_reservation
    task_role_arn      = aws_iam_role.task-role.arn
    task_exec_role_arn = aws_iam_role.task-exec-role.arn
    app_port           = var.app_port
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
  iam_role                           = var.iam_role_arn
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = var.grace_period

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

  load_balancer {
    target_group_arn = aws_alb_target_group.this.arn
    container_name   = "${var.service_name}-${terraform.workspace}"
    container_port   = var.app_port
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb_listener_rule.https_rule, aws_iam_role_policy.secrets-manager-ecs-task, aws_iam_role_policy.ecs-task-exec]
}

resource "aws_alb_target_group" "this" {
  name                 = substr("${var.service_name}-${terraform.workspace}", 0, 31)
  port                 = var.app_port
  protocol             = var.tg_protocol
  deregistration_delay = 15
  vpc_id               = var.vpc_id

  health_check {
    path                = var.path
    matcher             = var.status
    timeout             = var.timeout
    interval            = var.interval
    healthy_threshold   = var.healthy
    unhealthy_threshold = var.unhealthy
    protocol            = var.tg_protocol
  }

  lifecycle {
    create_before_destroy = true
  }
}

variable "alb_priorities" {
  default = []
}

resource "aws_lb_listener_rule" "https_rule" {
  count        = length(var.route53_subdomains)
  listener_arn = var.alb_https_listener_arn
  priority     = var.alb_priorities[count.index] != null ? var.alb_priorities[count.index] : null

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }

  condition {
    host_header {
      values = ["${element(var.route53_subdomains, count.index)}${var.route53_domain}"]
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

variable "ecs_service_domain" {
  default = "services.kong.lunacare.net"
}

variable "path_prefix" {
  default = ""
}

resource "aws_lb_listener_rule" "https_prefix_path_rule" {
  count        = var.path_prefix != "" ? 1 : 0
  listener_arn = var.alb_https_listener_arn
  priority     = var.alb_priorities[count.index] != null ? var.alb_priorities[count.index] : null
  condition {
    path_pattern {
      values = [var.path_prefix]
    }
  }

  condition {
    host_header {
      values = [var.ecs_service_domain]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
  lifecycle {
    create_before_destroy = true
  }
}

variable "header_name" {
  default = ""
}

variable "header_value" {
  default = ""
}

resource "aws_lb_listener_rule" "https_header_value_rule" {
  count        = var.path_prefix != "" ? 1 : 0
  listener_arn = var.alb_https_listener_arn
  priority     = var.alb_priorities[count.index] != null ? var.alb_priorities[count.index] : null
  condition {
    http_header {
      http_header_name = var.header_name
      values           = [var.header_value]
    }
  }

  condition {
    host_header {
      values = [var.ecs_service_domain]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
  lifecycle {
    create_before_destroy = true
  }
}

# data "aws_route53_zone" "this" {
#   name         = "lunacare.private."
#   private_zone = true
# }

# variable "internal_alb_dns" {
#   default = []
# }
# 
# resource "aws_route53_record" "this" {
#   count   = var.create_records ? length(var.route53_subdomains) : 0
#   name    = var.route53_subdomains[count.index]
#   type    = "CNAME"
#   zone_id = data.aws_route53_zone.this.id
#   records = var.internal_alb_dns
#   ttl     = "300"
# }
# 
# data "aws_route53_zone" "kong" {
#   name         = "lunacare.kong."
#   private_zone = true
# }
# 
# resource "aws_route53_record" "kong" {
#   count   = var.create_records ? length(var.route53_subdomains) : 0
#   name    = var.route53_subdomains[count.index]
#   type    = "CNAME"
#   zone_id = data.aws_route53_zone.kong.id
#   records = var.internal_alb_dns
#   ttl     = "300"
# }
# 
# variable "create_records" {
#   default = false
# }
