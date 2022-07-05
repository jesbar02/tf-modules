provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source          = "../../aws_vpc"
  project         = "${var.project}"
  cidr_block      = "${var.cidr_block}"
  public_subnets  = ["${var.public_subnets}"]
  private_subnets = ["${var.private_subnets}"]
}

module "postgres" {
  source             = "../../aws_rds"
  project            = "${var.project}"
  password           = "${var.rds_password}"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]
}

module "redis" {
  source             = "../../aws_cache"
  project            = "${var.project}"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]
}
