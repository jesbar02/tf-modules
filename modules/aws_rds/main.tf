resource "aws_db_subnet_group" "this" {
  count       = var.create ? 1 : 0
  name        = "${var.project}-${terraform.workspace}-${replace(var.engine_family, ".", "")}"
  description = var.description
  subnet_ids  = var.subnet_ids

  tags = {
    Name        = "${var.project}-${terraform.workspace}-${replace(var.engine_family, ".", "")}"
    project     = var.project
    environment = terraform.workspace
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "this" {
  count       = var.create ? 1 : 0
  name        = "${var.project}-${terraform.workspace}-${replace(var.engine_family, ".", "")}"
  family      = var.engine_family
  description = var.description
  dynamic "parameter" {
    for_each = var.parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Security group for publicly accessible instances

data "aws_subnet" "this" {
  count = var.create ? 1 : 0
  id    = var.subnet_ids[0]
}

data "aws_vpc" "this" {
  count = var.create ? 1 : 0
  id    = data.aws_subnet.this[0].vpc_id
}

data "aws_security_group" "default" {
  count  = var.create ? 1 : 0
  name   = "default"
  vpc_id = data.aws_vpc.this[0].id
}

module "sg_rds" {
  source       = "../aws_sg"
  create       = var.publicly_accessible ? var.create : false
  project      = var.project
  suffix_name  = "rds"
  public_ports = var.port[var.engine[var.engine_family]]
  vpc_id       = data.aws_subnet.this[0].vpc_id
}

resource "aws_db_instance" "this" {
  count                     = var.create ? 1 : 0
  allocated_storage         = var.storage
  storage_type              = "gp2"
  engine                    = var.engine[var.engine_family]
  engine_version            = var.engine_version[var.engine_family]
  instance_class            = var.instance_type
  identifier                = "${var.project}-${terraform.workspace}${var.suffix != "" ? format("%s%s", "-", var.suffix) : ""}"
  name                      = "${replace(var.project, "-", "_")}${var.suffix != "" ? format("%s%s", "_", var.suffix) : ""}"
  username                  = "${replace(var.project, "-", "_")}${var.suffix != "" ? format("%s%s", "_", var.suffix) : ""}"
  password                  = var.password
  publicly_accessible       = var.publicly_accessible
  db_subnet_group_name      = aws_db_subnet_group.this[0].name
  vpc_security_group_ids    = var.publicly_accessible ? [module.sg_rds.id] : [data.aws_security_group.default[0].id]
  port                      = var.port[var.engine[var.engine_family]]
  parameter_group_name      = aws_db_parameter_group.this[0].id
  apply_immediately         = var.apply_immediately
  maintenance_window        = var.maintenance_window
  copy_tags_to_snapshot     = true
  final_snapshot_identifier = "${var.project}-${terraform.workspace}${var.suffix != "" ? format("%s%s", "-", var.suffix) : ""}-final-${replace(var.engine_family, ".", "")}"
  backup_retention_period   = var.backup_retention_days
  backup_window             = var.backup_window
  storage_encrypted         = true
  deletion_protection       = var.deletion_protection

  tags = {
    Name        = "${var.project}-${terraform.workspace}${var.suffix != "" ? format("%s%s", "-", var.suffix) : ""}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_db_instance" "read_replica" {
  count               = var.create_replica ? 1 : 0
  identifier          = "${var.project}-${terraform.workspace}${var.suffix != "" ? format("%s%s", "-", var.suffix) : ""}-read-replica"
  replicate_source_db = aws_db_instance.this[0].id
  instance_class      = var.instance_type
  skip_final_snapshot = true
  storage_encrypted   = true

  tags = {
    Name        = "${var.project}-${terraform.workspace}${var.suffix != "" ? format("%s%s", "-", var.suffix) : ""}--read-replica"
    project     = var.project
    environment = terraform.workspace
  }
}
