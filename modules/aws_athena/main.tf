resource "aws_athena_named_query" "athena_saved_queries" {
  name        = var.query_name
  workgroup   = var.workgroup_name
  database    = var.glue_database_name
  description = var.description
  query       = var.query_string
}
