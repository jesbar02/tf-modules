variable "create" {
  default = true
}

variable "project" {}

variable "ami" {}

variable "instance_type" {
  default = "t3.small"
}

variable "key_name" {}

variable "enable_monitoring" {
  default = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_groups" {}

variable "health_check_grace_period" {
  default = 0
}

variable "iam_instance_role_name" {
  default = ""
}

variable "min_sizes" {
  default = []
}

variable "max_sizes" {
  default = []
}

variable "sizes" {
  default = []
}

variable "sleep_time" {
  default = 0
}

variable "volume_type" {
  default = "gp2"
}

variable "root_block_device_size" {
  default = "30"
}

variable "draining_process_lambda_timeout" {
  default = 900
}

variable "draining_process_logs_retantion_days" {
  default = 14
}

variable "draining_process_lifecycle_timeout" {
  default = 3600
}

variable "scale_in_protection" {
  default = false
}

variable "cluster_names" {
  default = []
}

variable "instance_types" {
  default = []
}

variable "ec2_admin_users" {
  default = []
}

variable "ec2_dev_users" {
  default = []
}

variable "aws_region" {}
