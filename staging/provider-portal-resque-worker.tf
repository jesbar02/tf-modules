module "provider-portal-resque-worker" {
  source                          = "../modules//aws_worker/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[0]
  service_name                    = "provider-portal-resque-worker"
  docker_image                    = "${module.ecs.ecr_url}:provider-portal-service-staging-latest"
  memory_reservation              = 154
  desired_count                   = 1
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 1
  autoscaling_memory_target_value = 100
  aws_region                      = var.aws_region
  s3_environment_variables        = var.provider-portal-service-s3-env-vars
  # secrets_manager                 = var.provider-portal-service-secrets-manager
  cmd          = "[\"bundle\", \"exec\", \"rake\", \"resque:work\"]"
  bucket_names = var.provider-portal-service-bucket-names
}

output "provider-portal-resque-worker-task-definition-json" {
  value = module.provider-portal-resque-worker.task_definition_json
}
