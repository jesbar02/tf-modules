variable "create" {
  default = true
}

variable "project" {}

variable "key_name" {}

variable "default_admin_user" {
  default = "ubuntu"
}

variable "ec2_admins" {
  default = []
}

variable "ec2_users" {
  default = []
}

variable "elastic_ip" {
  default = false
}

variable "public_subnet_id" {}

variable "source_cidr_blocks" {
  default = ["0.0.0.0/0"]
}

variable "ami" {
  default = ""
}

variable "instance_type" {
  default = "t3.micro"
}

variable "description" {
  default = "Managed by @Koombea"
}

