variable "create" {
  default = true
}

variable "project" {}

variable "description" {
  default = "Managed by @Koombea"
}

variable "engine" {
  default = {
    "redis3.2"     = "redis"
    "redis4.0"     = "redis"
    "redis5.0"     = "redis"
    "redis6.x"     = "redis"
    "memcached1.4" = "memcached"
  }
}

variable "engine_family" {
  default = "redis5.0"
}

variable "engine_version" {
  default = {
    "redis3.2"     = "3.2.10"
    "redis4.0"     = "4.0.10"
    "redis5.0"     = "5.0.6"
    "redis6.x"     = "6.x"
    "memcached1.4" = "1.4.34"
  }
}

variable "parameter_group_family" {
  default = {
    "redis3.2"     = "3.2"
    "redis4.0"     = "4.0"
    "redis5.0"     = "5.0"
    "redis6.x"     = "6.x"
    "memcached1.4" = "1.4"
  }
}

variable "port" {
  default = {
    "redis"     = "6379"
    "memcached" = "11211"
  }
}

variable "node_type" {
  default = "cache.t3.small"
}

variable "number_cache_clusters" {
  default = 1
}

variable "security_group_ids" {}

variable "subnet_ids" {}

variable "parameters" {
  default = []
}

variable "transit_encryption" {
  default = true
}

variable "auth_token" {}
