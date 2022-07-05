output "arn" {
  value = element(concat(aws_alb.this.*.arn, [""]), 0)
}

output "dns_name" {
  value = element(concat(aws_alb.this.*.dns_name, [""]), 0)
}

output "zone_id" {
  value = element(concat(aws_alb.this.*.zone_id, [""]), 0)
}

output "https_arn" {
  value = element(concat(aws_alb_listener.https.*.arn, [""]), 0)
}

output "arn_suffix" {
  value = element(concat(aws_alb.this.*.arn_suffix, [""]), 0)
}
