module "kong-private-service" {
  source                          = "../modules//aws_service/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[2]
  service_name                    = "kong-private-service"
  docker_image                    = "${module.ecs.ecr_url}:kong-enterprise-latest"
  memory_reservation              = 256
  desired_count                   = 2
  autoscaling_min_capacity        = 2
  autoscaling_max_capacity        = 5
  autoscaling_memory_target_value = 100
  autoscaling_alb_target_value    = 300
  grace_period                    = 10
  app_port                        = 8443
  status                          = "404,400"
  tg_protocol                     = "HTTPS"
  aws_region                      = var.aws_region
  iam_role_arn                    = module.ecs.iam_service_role_arn
  vpc_id                          = module.vpc.id
  alb_https_listener_arn          = module.ecs.alb_https_private_listener_arn
  route53_domain                  = "kong.lunacare.co"
  route53_subdomains              = ["*.", ""]
  path                            = "/"
  s3_environment_variables        = var.kong-service-s3-env-vars
  # secrets_manager                 = var.kong-service-secrets-manager
  cmd             = "[\"kong\", \"docker-start\"]"
  alb_suffix      = module.ecs.alb_private_arn_suffix
  alarm_topic_arn = var.alarm_topic_arn
  alb_priorities  = [49999, 50000]
}

output "kong-private-service-task-definition-json" {
  value = module.kong-private-service.task_definition_json
}
