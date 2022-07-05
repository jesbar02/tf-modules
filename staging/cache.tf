module "cache" {
  source             = "../modules//aws_cache/"
  project            = var.project
  engine_family      = "redis5.0"
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.default_sg_id]
  # transit_encryption = false
}
