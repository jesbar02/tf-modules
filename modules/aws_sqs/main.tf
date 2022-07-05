resource "aws_sqs_queue" "terraform_queue" {
  name                        = "${var.project}-${terraform.workspace}-${var.service_name}${var.fifo ? ".fifo" : ""}"
  fifo_queue                  = true
  delay_seconds               = 0
  max_message_size            = 262144
  message_retention_seconds   = 1209600
  receive_wait_time_seconds   = 0
  content_based_deduplication = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_dead_letter.arn
    maxReceiveCount     = 5
  })

  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_sqs_queue" "terraform_queue_dead_letter" {
  name                        = "${var.project}-${terraform.workspace}-${var.service_name}-dead-letter${var.fifo ? ".fifo" : ""}"
  fifo_queue                  = true
  delay_seconds               = 0
  max_message_size            = 262144
  message_retention_seconds   = 1209600
  receive_wait_time_seconds   = 0
  content_based_deduplication = true

  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}
