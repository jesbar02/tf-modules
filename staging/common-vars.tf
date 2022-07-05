variable "project" {
  default = "luna"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "route53_internal_domain" {
  default = "private.lunacare.co"
}

variable "route53_public_domain" {
  default = "lunacare.co"
}

variable "alarm_topic_arn" {
  default = "arn:aws:sns:us-west-2:672877676973:luna-staging-alarms"
}

# Kong

variable "kong-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "kong-service.env"]
}

# Marketplace

variable "marketplace-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "marketplace-service.env"]
}

variable "marketplace-service-secrets-manager" {
  default = ["luna-staging-marketplace-service", "arn:aws:secretsmanager:us-west-2:672877676973:secret:luna-staging-marketplace-service-1hsn4v"]
}

variable "marketplace-service-sqs-queues" {
  default = ["arn:aws:sqs:us-west-2:672877676973:luna-staging-marketplace.fifo", "arn:aws:sqs:us-west-2:672877676973:luna-staging-marketplace-dead-letter.fifo"]
}

variable "marketplace-service-bucket-names" {
  default = ["luna-staging-auto-charting"]
}

# Provider Portal

variable "provider-portal-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "provider-portal-service.env"]
}

variable "provider-portal-service-bucket-names" {
  default = ["luna-staging-auto-charting", "luna-staging-customer-documents"]
}

# Edge

variable "edge-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "edge-service.env"]
}

variable "edge-service-bucket-names" {
  default = ["luna-staging-auto-charting", "luna-staging-therapist-profile-images", "luna-staging-customer-documents", "luna-staging-region-launch-config"]
}

# Patient Self Report

variable "patient-self-report-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "patient-self-report-service.env"]
}

variable "patient-self-report-service-bucket-names" {
  default = ["luna-production-patient-signatures", "luna-staging-patient-signatures"]
}

# Forms

variable "forms-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "forms-service.env"]
}

# Therapist Signup

variable "therapist-signup-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "therapist-signup-service.env"]
}

variable "therapist-signup-service-bucket-names" {
  default = ["luna-staging-therapist-signup"]
}

# Success

variable "success-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "success-service.env"]
}

# Marketing Site Backend

variable "marketing-backend-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "marketing-backend-service.env"]
}

# Marketing Site Frontend

variable "marketing-frontend-service-s3-env-vars" {
  default = ["luna-staging-environment-variables", "marketing-frontend-service.env"]
}
