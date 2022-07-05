variable "database_name" {
  default = ""
}
variable "columns" {
  default = []
}
variable "parameters" {
  default = []
}
variable "partition_keys" {
  default = []
}
variable "table_name" {
  default = ""
}
variable "db_catalog_name" {
  default = ""
}
variable "classification" {
  default = ""
}
variable "field_delim_param" {
  default = null
}
variable "serialization_format" {
  default = null
}
variable "skip_header_line_count" {
  default = null
}
variable "size_key" {
  default = null
}
variable "object_count" {
  default = null
}
variable "parquet_crawler_schema_serializer_version" {
  default = null
}
variable "crawler_classifiers" {
  default = ""
}
variable "header" {
  default = ""
}
variable "s3_location" {
  default = ""
}
variable "input_format" {
  default = ""
}
variable "output_format" {
  default = ""
}
variable "serialization_library" {
  default = ""
}
variable "crawler_db_name" {
  default = ""
}
variable "crawler_name" {
  default = ""
}
variable "crawler_role" {
  default = ""
}
variable "crawler_schedule" {
  default = ""
}
variable "crawler_path" {
  default = ""
}
variable "update_behavior" {
  default = "UPDATE_IN_DATABASE"
}
variable "delete_behavior" {
  default = "DEPRECATE_IN_DATABASE"
}
variable "csv_classifier_name" {
  default = ""
}
variable "contains_header" {
  default = ""
}
variable "delimiter" {
  default = ""
}
variable "quote_symbol" {
  default = ""
}
variable "allow_single_column" {
  default = false
}
variable "disable_value_trimming" {
  default = false
}
