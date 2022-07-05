output "arn" {
  value = element(compact(concat(aws_ecr_repository.this.*.arn, ["-"])), 0)
}

output "url" {
  value = element(
    compact(concat(aws_ecr_repository.this.*.repository_url, ["-"])),
    0,
  )
}

