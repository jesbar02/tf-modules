module "patients_table_luxe_production_db" {
  source                = "../modules//aws_glue/"
  table_name            = "patients"
  db_catalog_name       = "luxe-production-db"
  s3_location           = "s3://luna-staging-data-lake/luxe-pipeline/staging/patients/"
  input_format          = "org.apache.hadoop.mapred.TextInputFormat"
  output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
  serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

  # Serde parameters
  field_delim_param = "|"

  # Table properties
  classification         = "csv"
  skip_header_line_count = 1

  columns = [
    {
      name = "id",
      type = "string"
    },
    {
      name = "first_name",
      type = "string"
    },
    {
      name = "last_name",
      type = "string"
    },
    {
      name = "gender",
      type = "string"
    },
    {
      name = "age",
      type = "double"
    },
    {
      name = "partner_clinic_id",
      type = "string"
    },
    {
      name = "discharged",
      type = "boolean"
    },
    {
      name = "physician_id",
      type = "string"
    },
    {
      name = "completed_visits_count",
      type = "bigint"
    },
    {
      name = "pending_visits_count",
      type = "bigint"
    },
    {
      name = "earliest_visit_date",
      type = "string"
    },
    {
      name = "latest_visit_date",
      type = "string"
    },
    {
      name = "partition_0"
      type = "string"
    },
  ]
}

