module "edge-service" {
  source                          = "../modules//aws_service/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[1]
  service_name                    = "edge-service"
  docker_image                    = "${module.ecs.ecr_url}:edge-service-staging-latest"
  memory_reservation              = 680
  desired_count                   = 2
  autoscaling_min_capacity        = 2
  autoscaling_max_capacity        = 2
  autoscaling_memory_target_value = 100
  autoscaling_alb_target_value    = 300
  grace_period                    = 10
  app_port                        = 3000
  status                          = "200,301"
  tg_protocol                     = "HTTP"
  aws_region                      = var.aws_region
  iam_role_arn                    = module.ecs.iam_service_role_arn
  vpc_id                          = module.vpc.id
  alb_https_listener_arn          = module.ecs.alb_https_private_listener_arn
  route53_domain                  = var.route53_internal_domain
  route53_subdomains              = ["edge."]
  path                            = "/okcomputer/all.json"
  s3_environment_variables        = var.edge-service-s3-env-vars
  # secrets_manager                 = var.edge-service-secrets-manager
  cmd             = "[\"bundle\", \"exec\", \"rails\", \"s\", \"-b\", \"0.0.0.0\"]"
  bucket_names    = var.edge-service-bucket-names
  alb_suffix      = module.ecs.alb_private_arn_suffix
  alb_priorities  = [10]
  alarm_topic_arn = var.alarm_topic_arn
  # path_prefix     = "/edge*"
  # header_name     = "X-Luna-Destination-Service"
  # header_value    = "edge"
}

output "edge-service-task-definition-json" {
  value = module.edge-service.task_definition_json
}
