# module "cronjobs" {
#   source              = "../modules//aws_cronjobs/"
#   project             = var.project
#   service_name        = "backend-service"
#   cron_name           = ["import-opis-truck-stops"]
#   task_definition_arn = module.backend-service.task_definition_arn
#   role_arn            = module.ecs.iam_event_role_arn
#   cron_expression     = ["30 3 * * ? *"]
#   cmd                 = ["\"rake\", \"import_opis_truck_stops\""]
# }
