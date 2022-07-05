variable "create" {
  default = true
}

variable "project" {}

variable "description" {
  default = "Managed by @Koombea"
}

variable "suffix_name" {}

variable "vpc_id" {}

variable "admin_source_ips" {
  default = []
}

variable "admin_port_from" {
  default = "22"
}

variable "admin_port_to" {
  default = "22"
}

variable "admin_proto" {
  default = "TCP"
}

variable "public_ports" {
  default = []
}

variable "public_ports_from" {
  default = ["0.0.0.0/0"]
}

variable "allow_own_traffic" {
  default = false
}

