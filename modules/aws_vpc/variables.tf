variable "project" {}

variable "cidr_block" {}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = false
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "nat_gateway" {
  default = false
}