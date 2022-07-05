data "aws_subnet" "this" {
  count = var.create ? 1 : 0
  id    = var.public_subnet_id
}

data "aws_vpc" "this" {
  count = var.create ? 1 : 0
  id    = data.aws_subnet.this[0].vpc_id
}

module "ssh" {
  create           = var.create
  source           = "../aws_sg"
  project          = var.project
  suffix_name      = "ssh-bastion"
  admin_source_ips = var.source_cidr_blocks
  vpc_id           = data.aws_vpc.this[0].id
}

data "aws_ami" "this" {
  count       = var.create && var.ami == "" ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "this" {
  count                       = var.create ? 1 : 0
  ami                         = var.ami == "" ? element(concat(data.aws_ami.this.*.id, ["-"]), 0) : var.ami
  instance_type               = var.instance_type
  disable_api_termination     = false
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [module.ssh.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                apt update
                apt -y install python
              EOF


  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.project}-${terraform.workspace}-bastion"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_eip" "this" {
  count    = var.create && var.elastic_ip ? 1 : 0
  instance = aws_instance.this[0].id
  vpc      = true

  tags = {
    Name        = "${var.project}-${terraform.workspace}-bastion"
    project     = var.project
    environment = terraform.workspace
  }
}

data "template_file" "ansible" {
  count    = var.create ? 1 : 0
  template = file("${path.module}/ansible/variables.json")

  vars = {
    base_hostname = "${var.project}-${terraform.workspace}-bastion"
    admins        = jsonencode(var.ec2_admins)
    users         = jsonencode(var.ec2_users)
  }
}

