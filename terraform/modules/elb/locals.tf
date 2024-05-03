locals {
  target_fqdn    = "${var.elb_cert_target_subdomain}.${data.aws_route53_zone.target_zone.name}"
  cert_tags      = merge(var.global_tags, var.elb_cert_tags)
  lb_tags        = merge(var.global_tags, var.elb_lb_tags)
  tg_tags        = merge(var.global_tags, var.elb_tg_tags)
  elb_isinternal = false
  elb_lb_type    = "application"
}