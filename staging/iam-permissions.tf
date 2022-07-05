# Groups

module "generals-group" {
  source     = "../modules//aws_managed_policies/"
  group_name = "generals-group"

  managed_policies = ["IAMUserChangePassword"]
}

module "automation-qa-group" {
  source     = "../modules//aws_managed_policies/"
  group_name = "automation-and-qa-group"

  custom_policies = ["AutomationAndQa"]
}

module "lunacare-developers-group" {
  source     = "../modules//aws_managed_policies/"
  group_name = "lunacare-developers-group"

  custom_policies = ["stripe-secrets"]
}

module "marketplace-group" {
  source       = "../modules//aws_iam_group/"
  project      = var.project
  service_name = "marketplace"

  dev_secret_arns          = ["arn:aws:secretsmanager:us-west-2:672877676973:secret:luna-staging-marketplace-service-1hsn4v"]
  s3_environment_variables = ["luna-staging-environment-variables", "marketplace-service.env"]
}

module "marketing-backend-group" {
  source       = "../modules//aws_iam_group/"
  project      = var.project
  service_name = "marketing-backend"

  s3_environment_variables = ["luna-staging-environment-variables", "marketing-backend-service.env"]
  dev_bucket_names         = ["luna-staging-marketing-backend-images"]
}

module "provider-portal-group" {
  source       = "../modules//aws_iam_group/"
  project      = var.project
  service_name = "provider-portal"

  managed_policies         = ["AmazonAthenaFullAccess", "AWSGlueConsoleFullAccess"]
  s3_environment_variables = ["luna-staging-environment-variables", "provider-portal-service.env"]
  dev_bucket_names         = ["luna-staging-data-lake", "luna-staging-athena-query-results", "luna-staging-auto-charting"]
}

module "therapist-signup-group" {
  source       = "../modules//aws_iam_group/"
  project      = var.project
  service_name = "therapist-signup"

  s3_environment_variables = ["luna-staging-environment-variables", "therapist-signup-service.env"]
  dev_bucket_names         = ["luna-staging-therapist-signup-agreement-pdfs", "luna-staging-therapist-signup"]
}

module "forms-group" {
  source       = "../modules//aws_iam_group/"
  project      = var.project
  service_name = "forms"

  s3_environment_variables = ["luna-staging-environment-variables", "forms-service.env"]
}

module "patient-self-report-group" {
  source       = "../modules//aws_iam_group/"
  project      = var.project
  service_name = "patient-self-report"

  s3_environment_variables = ["luna-staging-environment-variables", "patient-self-report-service.env"]
}

# Users

# module "SteveSims-user" {
#   source  = "../modules//aws_iam_user/"
#   project = var.project
#   user    = "steve.sims"
#   groups  = ["lunacare-developers-group", "generals-group"]
# }

# module "AnthonyHernandez-user" {
#   source  = "../modules//aws_iam_user/"
#   project = var.project
#   user    = "anthony.hernandez"
#   groups  = ["generals-group"]
# }

module "JeferssonBustamante-user" {
  source  = "../modules//aws_iam_user/"
  project = var.project
  user    = "jefersson.bustamante"
  groups  = ["luna-marketing-backend-staging-developers"]
}

module "FranciscoQuintero-user" {
  source  = "../modules//aws_iam_user/"
  project = var.project
  user    = "francisco.quintero"
  groups = ["luna-provider-portal-staging-developers", "luna-therapist-signup-staging-developers",
  "luna-forms-staging-developers", "luna-patient-self-report-staging-developers"]
}

module "PabloMoreno-user" {
  source  = "../modules//aws_iam_user/"
  project = var.project
  user    = "pablo.moreno"
  groups  = ["automation-and-qa-group", "generals-group"]
}

module "IvanBarona-user" {
  source  = "../modules//aws_iam_user/"
  project = var.project
  user    = "ivan.barona"
  groups  = ["automation-and-qa-group", "generals-group"]
}

module "OscaDeMoya-user" {
  source  = "../modules//aws_iam_user/"
  project = var.project
  user    = "osca.demoya"
  groups  = ["automation-and-qa-group", "generals-group"]
}

module "Automation-user" {
  source  = "../modules//aws_iam_user/"
  project = var.project
  user    = "automation"
  groups  = ["automation-and-qa-group"]
}
