variable "create" {
  default = true
}

variable "project" {}

variable "password" {}

variable "description" {
  default = "Managed by @Koombea"
}

variable "suffix" {
  default = ""
}

variable "engine" {
  default = {
    "postgres12"  = "postgres"
    "postgres13"  = "postgres"
    "postgres10"  = "postgres"
    "postgres9.6" = "postgres"
    "mysql5.7"    = "mysql"
    "mysql5.6"    = "mysql"
  }
}

variable "engine_family" {
  default = "postgres12"
}

variable "engine_version" {
  default = {
    "postgres12"  = "12.5"
    "postgres13"  = "13.2"
    "postgres10"  = "10.13"
    "postgres9.6" = "9.6.8"
    "mysql5.7"    = "5.7.21"
    "mysql5.6"    = "5.6.39"
  }
}

variable "port" {
  default = {
    "postgres" = "5432"
    "mysql"    = "3306"
  }
}

variable "storage" {
  default = 20
}

variable "instance_type" {
  default = "db.t3.small"
}

variable "publicly_accessible" {
  default = false
}

variable "security_group_ids" {}

variable "subnet_ids" {
  type = list(string)
}

variable "apply_immediately" {
  default = true
}

variable "maintenance_window" {
  default = "mon:13:00-mon:16:00"
}

variable "backup_retention_days" {
  default = 7
}

variable "backup_window" {
  default = "05:00-05:30"
}

variable "parameters" {
  default = []
}

variable "deletion_protection" {
  default = true
}

variable "create_replica" {
  default = false
}
