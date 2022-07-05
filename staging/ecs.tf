module "ecs" {
  source                         = "../modules//aws_ecs/"
  project                        = var.project
  aws_region                     = var.aws_region
  cluster_names                  = ["workers", "services", "kong"]
  ec2_instance_types             = ["m5.large", "m5.large", "t3.medium"]
  asg_min_sizes                  = [1, 1, 1]
  asg_sizes                      = [1, 1, 1]
  asg_max_sizes                  = [5, 5, 5]
  ecr                            = true
  alb_public_security_group_ids  = [module.vpc.default_sg_id, module.sg_http.id, module.sg_https.id]
  alb_private_security_group_ids = [module.vpc.default_sg_id, module.sg_http.id, module.sg_https.id]
  acm_public_arn                 = module.acm.arn
  acm_private_arn                = module.acm-private.arn
  acm_private_alternate_arn      = [module.acm-kong.arn]
  ec2_key_name                   = "luna-staging"
  ec2_admin_users                = ["gaffney", "jesbar02", "AndrewsHerrera"]
  ec2_dev_users                  = ["sas-luna", "hernanat", "milieu", "cesc1989"]
  ec2_security_group_ids         = [module.vpc.default_sg_id]
  vpc_ec2_subnet_ids             = module.vpc.private_subnet_ids
  vpc_public_subnet_ids          = module.vpc.public_subnet_ids
  vpc_private_subnet_ids         = module.vpc.private_subnet_ids
  tag_prefixes                   = ["luna-"]
  alb_private                    = true
}
