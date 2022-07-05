module "marketplace-sqs" {
  source       = "../modules//aws_sqs/"
  project      = var.project
  service_name = "marketplace"
}
