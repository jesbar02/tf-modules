# resource "aws_cloudwatch_log_group" "encrypted" {
#   count      = var.ssm_log_group_kms_arn != "" ? 1 : 0
#   name       = "session-manager"
#   kms_key_id = var.ssm_log_group_kms_arn
# 
#   tags = {
#     Name        = "${var.project}-${terraform.workspace}"
#     project     = var.project
#     environment = terraform.workspace
#   }
# }
# 
# resource "aws_cloudwatch_log_group" "ssm" {
#   name  = "session-manager"
# 
#   tags = {
#     Name        = "${var.project}-${terraform.workspace}"
#     project     = var.project
#     environment = terraform.workspace
#   }
# }
