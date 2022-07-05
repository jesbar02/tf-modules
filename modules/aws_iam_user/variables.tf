variable "create" {
  default = true
}

variable "project" {}
variable "user" {
  default = ""
}
variable "groups" {}
# variable "s3_environment_variables" {}
# variable "dev_secret_arns" {
#   default = []
# }
# variable "webhook_url" {
#   default = ""
# }
# 
# variable "deployment_process_lambda_timeout" {
#   default = 660
# }
# 
# variable "deployment_process_logs_retantion_days" {
#   default = 14
# }
# 
# variable "ssm_log_group_kms_arn" {
#   default = ""
# }
# variable "dev_bucket_names" {
#   default = []
# }
