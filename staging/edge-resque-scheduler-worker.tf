module "edge-resque-scheduler-worker" {
  source                          = "../modules//aws_worker/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[0]
  service_name                    = "edge-resque-scheduler-worker"
  docker_image                    = "${module.ecs.ecr_url}:edge-service-staging-latest"
  memory_reservation              = 256
  desired_count                   = 1
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 1
  autoscaling_memory_target_value = 100
  aws_region                      = var.aws_region
  s3_environment_variables        = var.edge-service-s3-env-vars
  # secrets_manager                 = var.edge-service-secrets-manager
  cmd          = "[\"bundle\", \"exec\", \"rake\", \"resque:scheduler\"]"
  bucket_names = var.edge-service-bucket-names
}

output "edge-resque-scheduler-worker-task-definition-json" {
  value = module.edge-resque-scheduler-worker.task_definition_json
}
