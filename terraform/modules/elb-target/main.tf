data "aws_route53_zone" "target_zone" {
  name = var.elb_target_zone
}

resource "aws_acm_certificate" "elb_cert" {
  domain_name       = local.target_fqdn
  validation_method = var.elb_cert_validation_method

  tags = local.cert_tags
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.elb_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = var.elb_allow_dns_overwrite
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.elb_dns_record_ttl
  type            = each.value.type
  zone_id         = data.aws_route53_zone.target_zone.zone_id
}

resource "aws_acm_certificate_validation" "elb_cert" {
  certificate_arn         = aws_acm_certificate.elb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_lb_target_group" "ecs" {
  name        = var.elb_tg_name
  port        = var.elb_tg_port
  protocol    = var.elb_tg_protocol
  vpc_id      = var.vpc.id
  target_type = var.elb_tg_target_type

  health_check {
    enabled             = var.elb_tg_hc_enable
    interval            = var.elb_tg_hc_interval
    path                = var.elb_tg_hc_path
    timeout             = var.elb_tg_hc_timeout
    matcher             = var.elb_tg_hc_match
    healthy_threshold   = var.elb_tg_hc_healthy
    unhealthy_threshold = var.elb_tg_hc_unhealthy
  }

  tags = local.tg_tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = var.elb.arn
  port              = var.elb_listener_port
  protocol          = var.elb_listener_protocol
  ssl_policy        = var.elb_listener_ssl_policy
  certificate_arn   = aws_acm_certificate_validation.elb_cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = var.elb.arn
  port              = var.elb_listener_redirector_port
  protocol          = var.elb_listener_redirector_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
