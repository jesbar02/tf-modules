module "acm" {
  source            = "../modules//aws_acm/"
  project           = var.project
  domain_name       = var.route53_public_domain
  alternative_names = ["*.lunacare.co"]
  route53           = false
}

module "acm-kong" {
  source            = "../modules//aws_acm/"
  project           = var.project
  domain_name       = "kong.${var.route53_public_domain}"
  alternative_names = ["*.kong.${var.route53_public_domain}"]
  route53           = false
}

module "acm-private" {
  source            = "../modules//aws_acm/"
  project           = var.project
  domain_name       = "private.${var.route53_public_domain}"
  alternative_names = ["*.private.${var.route53_public_domain}"]
  route53           = false
}
