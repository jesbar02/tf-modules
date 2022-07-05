data "aws_ami" "ecs" {
  count       = var.create ? 1 : 0
  most_recent = true
  owners      = ["591542846629"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_cloudwatch_log_group" "encrypted" {
  count             = var.logs_kms_arn != "" ? 1 : 0
  name              = "${var.project}-${terraform.workspace}"
  retention_in_days = var.cloudwatch_logs_retention_days
  kms_key_id        = var.logs_kms_arn

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.logs_kms_arn == "" ? 1 : 0
  name              = "${var.project}-${terraform.workspace}"
  retention_in_days = var.cloudwatch_logs_retention_days

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}

# Session Manager Log Group

resource "aws_cloudwatch_log_group" "encrypted-ssm" {
  count      = var.ssm_log_group_kms_arn != "" ? 1 : 0
  name       = "session-manager"
  kms_key_id = var.ssm_log_group_kms_arn

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "ssm" {
  name = "session-manager"

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}
