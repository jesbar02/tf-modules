variable "project" {
  default = "rails"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "cidr_block" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "rds_password" {}
