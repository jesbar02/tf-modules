variable "create" {
  default = true
}

variable "project" {}
variable "service_name" {}
variable "s3_environment_variables" {}
variable "dev_secret_arns" {
  default = []
}
variable "dev_bucket_names" {
  default = []
}
variable "managed_policies" {
  default = []
}
variable "custom_policies" {
  default = []
}
