module "marketplace-service" {
  source                          = "../modules//aws_service/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[1]
  service_name                    = "marketplace-service"
  docker_image                    = "${module.ecs.ecr_url}:marketplace-service-staging-latest"
  memory_reservation              = 900
  desired_count                   = 1
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 1
  autoscaling_memory_target_value = 100
  autoscaling_alb_target_value    = 300
  grace_period                    = 10
  app_port                        = 80
  status                          = "200,301"
  tg_protocol                     = "HTTP"
  aws_region                      = var.aws_region
  iam_role_arn                    = module.ecs.iam_service_role_arn
  vpc_id                          = module.vpc.id
  alb_https_listener_arn          = module.ecs.alb_https_private_listener_arn
  route53_domain                  = var.route53_internal_domain
  route53_subdomains              = ["marketplace."]
  path                            = "/health"
  nofile_soft_limit               = 100000
  nofile_hard_limit               = 100000
  s3_environment_variables        = var.marketplace-service-s3-env-vars
  secrets_manager                 = var.marketplace-service-secrets-manager
  cmd                             = "[\"/start.sh\"]"
  bucket_names                    = var.marketplace-service-bucket-names
  sqs_queues                      = var.marketplace-service-sqs-queues
  alb_suffix                      = module.ecs.alb_private_arn_suffix
  alb_priorities                  = [15]
  alarm_topic_arn                 = var.alarm_topic_arn
  ses_from_addresses              = ["eng@getluna.com"]
  # path_prefix                     = "/marketplace*"
  # header_name                     = "X-Luna-Destination-Service"
  # header_value                    = "marketplace"
}

output "marketplace-service-task-definition-json" {
  value = module.marketplace-service.task_definition_json
}
