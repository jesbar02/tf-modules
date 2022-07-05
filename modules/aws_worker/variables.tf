variable "project" {}
variable "service_name" {}

variable "cmd" {
  default = []
}

variable "autoscaling_min_capacity" {
  default = 1
}

variable "autoscaling_max_capacity" {
  default = 2
}

variable "autoscaling_memory_target_value" {}

variable "s3_environment_variables" {}

variable "docker_image" {}
variable "memory_reservation" {}

variable "log_group" {
  default = ""
}
variable "aws_region" {}
variable "log_prefix" {
  default = ""
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

variable "cluster_id" {}

variable "nofile_soft_limit" {
  default = 1024
}

variable "nofile_hard_limit" {
  default = 4096
}
