variable "project" {}
variable "service_name" {}

variable "cmd" {
  default = []
}

variable "capacity_provider_weight" {
  default = 1
}
variable "capacity_provider_base" {
  default = 0
}

variable "desired_count" {
  default = 1
}

variable "iam_role_arn" {}

variable "grace_period" {
  default = 0
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "vpc_id" {}

variable "healthy" {
  default = 2
}

variable "unhealthy" {
  default = 2
}

variable "interval" {
  default = 16
}

variable "path" {}

variable "status" {
  default = "200,301"
}

variable "timeout" {
  default = 15
}

variable "route53_subdomains" {
  type    = list(string)
  default = []
}

variable "alb_https_listener_arn" {}
variable "route53_domain" {}

variable "s3_environment_variables" {}

variable "docker_image" {}
variable "memory_reservation" {}
variable "app_port" {
  default = 80
}
variable "log_group" {
  default = ""
}
variable "aws_region" {}
variable "log_prefix" {
  default = ""
}

variable "cluster_id" {}

variable "autoscaling_memory_target_value" {}
variable "autoscaling_alb_target_value" {}

variable "autoscaling_min_capacity" {
  default = 1
}

variable "autoscaling_max_capacity" {
  default = 2
}

variable "alb_suffix" {
  default = ""
}

variable "alarm_topic_arn" {
  default = ""
}

variable "nofile_soft_limit" {
  default = 1024
}

variable "nofile_hard_limit" {
  default = 4096
}
