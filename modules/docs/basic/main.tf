provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source          = "../../aws_vpc"
  project         = "basic-example"
  nat_gateway     = "${var.nat_gateway}"
  cidr_block      = "${var.cidr_block}"
  public_subnets  = ["${var.public_subnets}"]
  private_subnets = ["${var.private_subnets}"]
}
