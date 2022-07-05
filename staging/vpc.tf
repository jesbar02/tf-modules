module "vpc" {
  source               = "../modules//aws_vpc/"
  project              = var.project
  nat_gateway          = true
  enable_dns_hostnames = true
  cidr_block           = "10.2.0.0/16"
  public_subnets       = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24"]
  private_subnets      = ["10.2.100.0/24", "10.2.101.0/24", "10.2.102.0/24"]
}
