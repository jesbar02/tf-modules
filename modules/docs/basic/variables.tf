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

variable "nat_gateway" {
  default = false
}
