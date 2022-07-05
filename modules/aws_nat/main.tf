resource "aws_eip" "this" {
  count = var.create ? 1 : 0
  vpc   = true

  tags = {
    Name        = "${var.project}-${terraform.workspace}-nat"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.create ? 1 : 0
  allocation_id = aws_eip.this[0].id
  subnet_id     = var.public_subnet_id

  tags = {
    Name        = "${var.project}-${terraform.workspace}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_route" "route" {
  count                  = var.create ? 1 : 0
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

