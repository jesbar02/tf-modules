resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

variable "mx_records" {
  default = {}
}
resource "aws_route53_record" "mx" {
  for_each = var.mx_records
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.key
  type     = "MX"
  ttl      = "300"
  records  = each.value
}

variable "spf_records" {
  default = {}
}
resource "aws_route53_record" "spf" {
  for_each = var.spf_records
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.key
  type     = "SPF"
  ttl      = "300"
  records  = each.value
}

variable "txt_records" {
  default = {}
}
resource "aws_route53_record" "txt" {
  for_each = var.txt_records
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.key
  type     = "TXT"
  ttl      = "300"
  records  = each.value
}

variable "alias_records" {
  default = {}
}
resource "aws_route53_record" "alias" {
  for_each = var.alias_records
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.key
  type     = "A"

  alias {
    name                   = each.value[1]
    zone_id                = each.value[0]
    evaluate_target_health = true
  }
}

variable "a_records" {
  default = {}
}
resource "aws_route53_record" "a" {
  for_each = var.a_records
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.key
  type     = "A"
  ttl      = "300"
  records  = each.value
}

variable "cname_records" {
  default = {}
}
resource "aws_route53_record" "cname" {
  for_each = var.cname_records
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.key
  type     = "CNAME"
  ttl      = "300"
  records  = [each.value]
}

variable "ns_records" {
  default = {}
}
resource "aws_route53_record" "ns" {
  for_each = var.ns_records
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.key
  type     = "NS"
  ttl      = "300"
  records  = each.value
}
