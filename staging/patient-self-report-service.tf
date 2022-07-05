module "patient-self-report-service" {
  source                          = "../modules//aws_service/"
  project                         = var.project
  cluster_id                      = module.ecs.cluster_ids[1]
  service_name                    = "patient-self-report-service"
  docker_image                    = "${module.ecs.ecr_url}:patient-self-report-service-staging-latest"
  memory_reservation              = 256
  desired_count                   = 1
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 1
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
  route53_subdomains              = ["patient-self-report."]
  path                            = "/checks"
  s3_environment_variables        = var.patient-self-report-service-s3-env-vars
  # secrets_manager                 = var.patient-self-report-service-secrets-manager
  cmd             = "[\"bundle\", \"exec\", \"rails\", \"s\", \"-b\", \"0.0.0.0\"]"
  bucket_names    = var.patient-self-report-service-bucket-names
  alb_suffix      = module.ecs.alb_private_arn_suffix
  alarm_topic_arn = var.alarm_topic_arn
  # path_prefix     = "/patient-self-report*"
  # header_name     = "X-Luna-Destination-Service"
  # header_value    = "patient-self-report"
  alb_priorities  = [35]
}

output "patient-self-report-service-task-definition-json" {
  value = module.patient-self-report-service.task_definition_json
}
