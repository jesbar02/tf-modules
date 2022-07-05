data "aws_vpc" "this" {
  count = var.create ? 1 : 0
  id    = var.vpc_id
}

data "aws_route_tables" "this" {
  count  = var.create
  vpc_id = var.vpc_id
}

resource "aws_subnet" "this" {
  count                   = var.create
  vpc_id                  = data.aws_vpc.this[0].id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.public

  tags = {
    Name        = "${var.project}-${terraform.workspace}-${var.public ? "public" : "private"}-${var.availability_zone}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_route_table_association" "this" {
  count          = var.create
  subnet_id      = aws_subnet.this[0].id
  route_table_id = var.public ? element(data.aws_route_tables.this[0].ids, 1) : element(data.aws_route_tables.this[0].ids, 0)
  depends_on     = [aws_subnet.this]
}

