output "id" {
  value = element(concat(aws_nat_gateway.this.*.id, ["-"]), 0)
}

output "ip" {
  value = element(concat(aws_eip.this.*.public_ip, ["-"]), 0)
}

