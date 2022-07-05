output "id" {
  value = "and_id"
}

output "ami" {
  value = var.ami == "" ? element(concat(data.aws_ami.this.*.id, ["-"]), 0) : var.ami
}

output "private_ip" {
  value = element(concat(aws_instance.this.*.private_ip, ["-"]), 0)
}

output "public_ip" {
  value = var.elastic_ip ? element(concat(aws_eip.this.*.public_ip, ["-"]), 0) : element(concat(aws_instance.this.*.public_ip, ["-"]), 0)
}

output "ansible" {
  value = "ansible-playbook --user ${var.default_admin_user} -i ${var.elastic_ip ? element(concat(aws_eip.this.*.public_ip, ["-"]), 0) : element(concat(aws_instance.this.*.public_ip, ["-"]), 0)}, --extra-vars ${element(concat(data.template_file.ansible.*.rendered, ["-"]), 0)} ${path.module}/ansible/playbook.yml"
}

