output "arn" {
  value = element(concat(aws_acm_certificate.this.*.arn, [""]), 0)
}

output "validations" {
  value = flatten(aws_acm_certificate.this.*.domain_validation_options)
}

