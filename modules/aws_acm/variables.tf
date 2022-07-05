variable "create" {
  default = true
}

variable "project" {}

variable "domain_name" {}

variable "alternative_names" {
  default = []
}

variable "route53" {
  default = false
}

