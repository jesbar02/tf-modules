module "marketing-frontend-service" {
  source                          = "../modules//aws_service/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[1]
  service_name                    = "marketing-frontend-service"
  docker_image                    = "${module.ecs.ecr_url}:marketing-frontend-service-staging-latest"
  memory_reservation              = 170
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
  route53_subdomains              = ["www."]
  path                            = "/"
  s3_environment_variables        = var.marketing-frontend-service-s3-env-vars
  # secrets_manager                 = var.marketing-frontend-service-secrets-manager
  cmd             = "[\"/usr/sbin/apache2ctl\", \"-D\", \"FOREGROUND\"]"
  alb_suffix      = module.ecs.alb_private_arn_suffix
  alarm_topic_arn = var.alarm_topic_arn
  alb_priorities  = [30]
}

output "marketing-frontend-service-task-definition-json" {
  value = module.marketing-frontend-service.task_definition_json
}
