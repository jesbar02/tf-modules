module "marketplace-rq-echo-worker" {
  source                          = "../modules//aws_worker/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[0]
  service_name                    = "marketplace-rq-echo-worker"
  docker_image                    = "${module.ecs.ecr_url}:marketplace-service-staging-latest"
  memory_reservation              = 256
  desired_count                   = 1
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 1
  autoscaling_memory_target_value = 100
  aws_region                      = var.aws_region
  nofile_soft_limit               = 50000
  nofile_hard_limit               = 50000
  s3_environment_variables        = var.marketplace-service-s3-env-vars
  secrets_manager                 = var.marketplace-service-secrets-manager
  cmd                             = "[\"rq\", \"worker\", \"-c\", \"marketplace.settings_rq_worker_auto_charting\", \"--sentry-dsn\", \"\", \"--exception-handler\", \"marketplace.rq_exception_handlers.handle_exception\"]"
  bucket_names                    = var.marketplace-service-bucket-names
  sqs_queues                      = var.marketplace-service-sqs-queues
  ses_from_addresses              = ["eng@getluna.com"]
}

output "marketplace-rq-echo-worker-task-definition-json" {
  value = module.marketplace-rq-echo-worker.task_definition_json
}
