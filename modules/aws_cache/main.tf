resource "aws_elasticache_subnet_group" "this" {
  count       = var.create ? 1 : 0
  name        = "${var.project}-${terraform.workspace}-${replace(var.engine_family, ".", "")}"
  subnet_ids  = var.subnet_ids
  description = var.description
}

resource "aws_elasticache_parameter_group" "this" {
  count       = var.create ? 1 : 0
  name        = "${var.project}-${terraform.workspace}-${replace(var.engine_family, ".", "")}"
  family      = var.engine_family
  description = var.description
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

data "aws_availability_zones" "available" {}

resource "aws_elasticache_replication_group" "this" {
  engine                        = var.engine[var.engine_family]
  engine_version                = var.engine_version[var.engine_family]
  security_group_ids            = var.security_group_ids
  port                          = var.port[var.engine[var.engine_family]]
  availability_zones            = [data.aws_availability_zones.available.names[0]]
  replication_group_id          = format("%.10s-%.9s", lower(var.project), lower(terraform.workspace))
  replication_group_description = format("%.10s-%.9s", lower(var.project), lower(terraform.workspace))
  node_type                     = var.node_type
  number_cache_clusters         = var.number_cache_clusters
  parameter_group_name          = aws_elasticache_parameter_group.this[0].id
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = var.transit_encryption
  subnet_group_name             = aws_elasticache_subnet_group.this[0].name
  auth_token                    = var.auth_token

  tags = {
    Name        = "${var.project}-${terraform.workspace}-${replace(var.engine_family, ".", "")}"
    project     = var.project
    environment = terraform.workspace
  }
}

