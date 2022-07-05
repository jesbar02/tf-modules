module "partner_clinics_table_luxe_production_db" {
  source                = "../modules//aws_glue/"
  table_name            = "partner_clinics"
  db_catalog_name       = "luxe-production-db"
  s3_location           = "s3://luna-staging-data-lake/luxe-pipeline/staging/partner-clinics/"
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
      name = "name",
      type = "string"
    },
    {
      name = "code",
      type = "string"
    },
    {
      name = "parent_id",
      type = "string"
    },
    {
      name = "can_sign_patient_pocs",
      type = "boolean"
    },
    {
      name = "can_view_patient_charts",
      type = "boolean"
    },
    {
      name = "can_view_assigned_physicians",
      type = "boolean"
    },
    {
      name = "partition_0"
      type = "string"
    },
  ]
}

