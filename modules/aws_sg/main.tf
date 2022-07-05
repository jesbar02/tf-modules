resource "aws_security_group" "this" {
  count       = var.create ? 1 : 0
  name        = "${var.project}-${terraform.workspace}-${var.suffix_name}"
  vpc_id      = var.vpc_id
  description = var.description

  tags = {
    Name        = "${var.project}-${terraform.workspace}-${var.suffix_name}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_security_group_rule" "admin" {
  count             = var.create ? length(var.admin_source_ips) : 0
  type              = "ingress"
  description       = var.description
  from_port         = var.admin_port_from
  to_port           = var.admin_port_to
  protocol          = var.admin_proto
  cidr_blocks       = [element(var.admin_source_ips, count.index)]
  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "this" {
  count             = var.create ? length(var.public_ports) : 0
  type              = "ingress"
  description       = var.description
  from_port         = element(var.public_ports, count.index)
  to_port           = element(var.public_ports, count.index)
  protocol          = "tcp"
  cidr_blocks       = var.public_ports_from
  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "input" {
  count                    = var.create && var.allow_own_traffic ? 1 : 0
  type                     = "ingress"
  description              = var.description
  to_port                  = 0
  protocol                 = "-1"
  from_port                = 0
  source_security_group_id = aws_security_group.this[0].id
  security_group_id        = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "output" {
  count             = var.create ? 1 : 0
  type              = "egress"
  description       = var.description
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this[0].id
}

