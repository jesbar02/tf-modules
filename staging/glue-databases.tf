module "glue_database" {
  source        = "../modules//aws_glue/"
  database_name = "luxe-production-db"
}

module "glue_patient_forms_production_db" {
  source        = "../modules//aws_glue/"
  database_name = "patient-forms-production-db"
}
