module "rds" {
  source             = "../modules//aws_rds/"
  project            = var.project
  engine_family      = "postgres12"
  password           = var.rds_password
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.default_sg_id]
  instance_type      = "db.t3.small"
  create_replica     = true

  parameters = [
    {
      name  = "rds.log_retention_period"
      value = "1440"
    },
  ]
}

variable "rds_password" {}
