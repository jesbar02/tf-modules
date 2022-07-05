module "patient-self-report-resque-worker" {
  source                          = "../modules//aws_worker/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[0]
  service_name                    = "patient-self-report-resque-worker"
  docker_image                    = "${module.ecs.ecr_url}:patient-self-report-service-staging-latest"
  memory_reservation              = 154
  desired_count                   = 1
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 1
  autoscaling_memory_target_value = 100
  aws_region                      = var.aws_region
  s3_environment_variables        = var.patient-self-report-service-s3-env-vars
  # secrets_manager                 = var.patient-self-report-service-secrets-manager
  cmd          = "[\"bundle\", \"exec\", \"rake\", \"resque:work\"]"
  bucket_names = var.patient-self-report-service-bucket-names
}

output "patient-self-report-resque-worker-task-definition-json" {
  value = module.patient-self-report-resque-worker.task_definition_json
}
