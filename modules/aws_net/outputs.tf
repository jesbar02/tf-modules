output "id" {
  value = element(concat(aws_subnet.this.*.id, [""]), 0)
}

