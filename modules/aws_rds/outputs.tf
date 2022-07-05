output "endpoint" {
  value = element(concat(aws_db_instance.this.*.endpoint, [""]), 0)
}

output "address" {
  value = element(concat(aws_db_instance.this.*.address, [""]), 0)
}

output "subnet_group_id" {
  value = element(concat(aws_db_subnet_group.this.*.id, [""]), 0)
}

output "parameter_group_id" {
  value = element(concat(aws_db_parameter_group.this.*.id, [""]), 0)
}

