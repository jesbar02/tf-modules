module "luxe_production_pipeline_crawler" {
  source              = "../modules//aws_glue/"
  crawler_db_name     = "luxe-production-db"
  crawler_schedule    = "cron(34 00 * * ? *)"
  crawler_name        = "Luxe Production Pipeline"
  crawler_role        = "AWSGlueServiceRole-DefaultRole"
  crawler_classifiers = ["CSV Pipe Double-Quote Classifier"]
  crawler_path        = "s3://luna-uat-data-lake/luxe-pipeline/uat"
}
