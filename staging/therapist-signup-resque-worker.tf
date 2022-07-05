module "therapist-signup-resque-worker" {
  source                          = "../modules//aws_worker/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[0]
  service_name                    = "therapist-signup-resque-worker"
  docker_image                    = "${module.ecs.ecr_url}:therapist-signup-service-staging-latest"
  memory_reservation              = 165
  desired_count                   = 1
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 1
  autoscaling_memory_target_value = 100
  aws_region                      = var.aws_region
  s3_environment_variables        = var.therapist-signup-service-s3-env-vars
  # secrets_manager                 = var.therapist-signup-service-secrets-manager
  cmd          = "[\"bundle\", \"exec\", \"rake\", \"resque:work\"]"
  bucket_names = var.therapist-signup-service-bucket-names
}

output "therapist-signup-resque-worker-task-definition-json" {
  value = module.therapist-signup-resque-worker.task_definition_json
}
