variable "create" {
  default = true
}

variable "project" {}

variable "private" {
  default = false
}

variable "security_group_ids" {}

variable "subnet_ids" {
  type = list(string)
}

variable "acm_public_arn" {
  default = ""
}
variable "acm_private_arn" {
  default = ""
}

variable "acm_public_alternate_arn" {
  default = []
}

variable "acm_private_alternate_arn" {
  default = []
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}
