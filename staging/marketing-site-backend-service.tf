module "marketing-backend-service" {
  source                          = "../modules//aws_service/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[1]
  service_name                    = "marketing-backend-service"
  docker_image                    = "${module.ecs.ecr_url}:marketing-backend-service-staging-latest"
  memory_reservation              = 1024
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
  route53_domain                  = var.route53_public_domain
  route53_subdomains              = ["marketing-site."]
  path                            = "/"
  s3_environment_variables        = var.marketing-backend-service-s3-env-vars
  # secrets_manager                 = var.marketing-backend-service-secrets-manager
  cmd             = "[\"/usr/sbin/apache2ctl\", \"-D\", \"FOREGROUND\"]"
  alb_suffix      = module.ecs.alb_private_arn_suffix
  alarm_topic_arn = var.alarm_topic_arn
  alb_priorities  = [25]
}

output "marketing-backend-service-task-definition-json" {
  value = module.marketing-backend-service.task_definition_json
}
