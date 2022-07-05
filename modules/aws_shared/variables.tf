variable "create" {
  default = true
}

variable "project" {}
variable "ec2_dev_users" {
  default = []
}
variable "prod_dev_users" {
  default = []
}
variable "dev_secret_arns" {
  default = []
}
variable "prod_secret_arns" {
  default = []
}
variable "webhook_url" {
  default = ""
}

variable "deployment_process_lambda_timeout" {
  default = 660
}

variable "deployment_process_logs_retantion_days" {
  default = 14
}

variable "ssm_log_group_kms_arn" {
  default = ""
}
