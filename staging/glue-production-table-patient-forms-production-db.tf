module "glue_production_table_patient_forms_production_db" {
  source                = "../modules//aws_glue/"
  table_name            = "production"
  db_catalog_name       = "patient-forms-production-db"
  s3_location           = "s3://luna-staging-data-lake/patient-forms-pipeline/staging/"
  input_format          = "org.apache.hadoop.mapred.TextInputFormat"
  output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
  serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

  # Serde parameters
  field_delim_param = ","

  columns = [
    {
      name = "id",
      type = "bigint"
    },
    {
      name = "internal_id",
      type = "string"
    },
    {
      name = "quality_of_life",
      type = "string"
    },
    {
      name = "injury_name",
      type = "string"
    },
    {
      name = "forms_count",
      type = "bigint"
    },
    {
      name = "completed_forms_count",
      type = "bigint"
    },
    {
      name = "form_type",
      type = "string"
    },
    {
      name = "pain_0",
      type = "bigint"
    },
    {
      name = "psfs_0",
      type = "bigint"
    },
    {
      name = "answers_0",
      type = "double"
    },
    {
      name = "completed_at_0",
      type = "string"
    },
    {
      name = "created_at_0",
      type = "string"
    },
    {
      name = "pain_1",
      type = "bigint"
    },
    {
      name = "psfs_1",
      type = "bigint"
    },
    {
      name = "answers_1",
      type = "double"
    },
    {
      name = "completed_at_1",
      type = "string"
    },
    {
      name = "created_at_1",
      type = "string"
    },
    {
      name = "pain_2",
      type = "bigint"
    },
    {
      name = "psfs_2",
      type = "bigint"
    },
    {
      name = "answers_2",
      type = "double"
    },
    {
      name = "completed_at_2",
      type = "string"
    },
    {
      name = "created_at_2",
      type = "string"
    },
    {
      name = "pain_3",
      type = "bigint"
    },
    {
      name = "psfs_3",
      type = "bigint"
    },
    {
      name = "answers_3",
      type = "double"
    },
    {
      name = "completed_at_3",
      type = "string"
    },
    {
      name = "created_at_3",
      type = "string"
    },
    {
      name = "pain_4",
      type = "bigint"
    },
    {
      name = "psfs_4",
      type = "bigint"
    },
    {
      name = "answers_4",
      type = "double"
    },
    {
      name = "completed_at_4",
      type = "string"
    },
    {
      name = "created_at_4",
      type = "string"
    },
    {
      name = "pain_5",
      type = "bigint"
    },
    {
      name = "psfs_5",
      type = "bigint"
    },
    {
      name = "answers_5",
      type = "double"
    },
    {
      name = "completed_at_5",
      type = "string"
    },
    {
      name = "created_at_5",
      type = "string"
    },
    {
      name = "pain_6",
      type = "bigint"
    },
    {
      name = "psfs_6",
      type = "bigint"
    },
    {
      name = "answers_6",
      type = "double"
    },
    {
      name = "completed_at_6",
      type = "string"
    },
    {
      name = "created_at_6",
      type = "string"
    },
    {
      name = "pain_7",
      type = "bigint"
    },
    {
      name = "psfs_7",
      type = "bigint"
    },
    {
      name = "answers_7",
      type = "double"
    },
    {
      name = "completed_at_7",
      type = "string"
    },
    {
      name = "created_at_7",
      type = "string"
    },
    {
      name = "pain_8",
      type = "bigint"
    },
    {
      name = "psfs_8",
      type = "bigint"
    },
    {
      name = "answers_8",
      type = "double"
    },
    {
      name = "completed_at_8",
      type = "string"
    },
    {
      name = "created_at_8",
      type = "string"
    },
    {
      name = "pain_9",
      type = "bigint"
    },
    {
      name = "psfs_9",
      type = "bigint"
    },
    {
      name = "answers_9",
      type = "double"
    },
    {
      name = "completed_at_9",
      type = "string"
    },
    {
      name = "created_at_9",
      type = "string"
    },
    {
      name = "care_plan_id",
      type = "string"
    },
    {
      name = "progress_modality_0",
      type = "string"
    },
    {
      name = "progress_modality_1",
      type = "string"
    },
    {
      name = "progress_modality_2",
      type = "string"
    },
    {
      name = "progress_modality_3",
      type = "string"
    },
    {
      name = "progress_modality_4",
      type = "string"
    },
    {
      name = "progress_modality_5",
      type = "string"
    },
    {
      name = "progress_modality_6",
      type = "string"
    },
    {
      name = "progress_modality_7",
      type = "string"
    },
    {
      name = "progress_modality_8",
      type = "string"
    },
    {
      name = "progress_modality_9",
      type = "string"
    }
  ]

  # Table properties
  classification         = "scv"
  skip_header_line_count = 1
}
