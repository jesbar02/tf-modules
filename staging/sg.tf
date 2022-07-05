module "sg_http" {
  source       = "../modules//aws_sg/"
  project      = var.project
  suffix_name  = "http"
  public_ports = ["80"]
  vpc_id       = module.vpc.id
}

module "sg_https" {
  source       = "../modules//aws_sg/"
  project      = var.project
  suffix_name  = "https"
  public_ports = ["443"]
  vpc_id       = module.vpc.id
}
