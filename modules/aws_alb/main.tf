resource "aws_alb" "this" {
  count           = var.create ? 1 : 0
  name            = substr("${var.project}-${terraform.workspace}-${var.private ? "private" : "public"}", 0, 31)
  internal        = var.private
  security_groups = var.security_group_ids
  subnets         = var.subnet_ids

  tags = {
    Name        = "${var.project}-${terraform.workspace}-${var.private ? "private" : "public"}"
    project     = var.project
    environment = terraform.workspace
  }
}

resource "aws_alb_listener" "http" {
  count             = var.create ? 1 : 0
  load_balancer_arn = aws_alb.this[0].arn
  port              = 80

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  count             = var.create ? 1 : 0
  load_balancer_arn = aws_alb.this[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.private ? var.acm_private_arn : var.acm_public_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_certificate" "public-https" {
  count           = length(var.acm_public_alternate_arn)
  listener_arn    = aws_alb_listener.https[0].arn
  certificate_arn = var.acm_public_alternate_arn[count.index]
}

resource "aws_lb_listener_certificate" "private-https" {
  count           = length(var.acm_private_alternate_arn)
  listener_arn    = aws_alb_listener.https[0].arn
  certificate_arn = var.acm_private_alternate_arn[count.index]
}
