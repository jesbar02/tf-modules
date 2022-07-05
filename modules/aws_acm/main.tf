resource "aws_acm_certificate" "this" {
  count                     = var.create ? 1 : 0
  domain_name               = var.domain_name
  subject_alternative_names = var.alternative_names
  validation_method         = "DNS"

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "this" {
  count        = var.create && var.route53 ? 1 : 0
  name         = "${var.domain_name}."
  private_zone = false
}

# Optional Route53 config
#resource "aws_route53_record" "this" {
#  count   = var.create && var.route53 ? 1 : 0
#  name    = aws_acm_certificate.this[0].domain_validation_options[0].resource_record_name
#  type    = aws_acm_certificate.this[0].domain_validation_options[0].resource_record_type
#  zone_id = data.aws_route53_zone.this[0].id
#  records = [aws_acm_certificate.this[0].domain_validation_options[0].resource_record_value]
#  ttl     = 60
#}
