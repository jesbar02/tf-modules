variable "create" {
  default = true
}

variable "project" {}

variable "aws_region" {}

variable "cloudwatch_logs_retention_days" {
  default = 30
}

variable "ecr" {
  default = true
}

# Application Load Balancer
variable "alb_public_security_group_ids" {}

variable "alb_public" {
  default = true
}

variable "alb_private" {
  default = false
}

variable "alb_private_security_group_ids" {
  default = []
}

variable "acm_public_arn" {}
variable "acm_private_arn" {
  default = ""
}

variable "acm_public_alternate_arn" {
  default = []
}

variable "acm_private_alternate_arn" {
  default = []
}

# Launch configuration
variable "ec2_ami" {
  default = ""
}

variable "ec2_key_name" {}

variable "ec2_admin_users" {
  default = []
}

variable "ec2_dev_users" {
  default = []
}

variable "ec2_instance_types" {
  default = []
}

variable "ec2_enable_monitoring" {
  default = true
}

variable "ec2_volume_type" {
  default = "gp2"
}

variable "ec2_root_block_device_size" {
  default = "100"
}

variable "ec2_security_group_ids" {}

variable "vpc_ec2_subnet_ids" {
  type = list(string)
}

variable "vpc_public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "vpc_private_subnet_ids" {
  type    = list(string)
  default = []
}

# Auto scaling
variable "asg_min_sizes" {
  default = []
}

variable "asg_max_sizes" {
  default = []
}

variable "asg_sizes" {
  default = []
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
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
  default = true
}

variable "tag_prefixes" {}

variable "max_scaling_step" {
  default = 2
}

variable "min_scaling_step" {
  default = 1
}

variable "target_capacity" {
  default = 100
}

variable "managed_termination_protection" {
  default = "ENABLED"
}

variable "logs_kms_arn" {
  default = ""
}

variable "cluster_names" {
  default = []
}

variable "ssm_log_group_kms_arn" {
  default = ""
}
