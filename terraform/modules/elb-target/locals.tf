locals {
  target_fqdn = "${var.elb_cert_target_subdomain}.${data.aws_route53_zone.target_zone.name}"
  cert_tags   = merge(var.elb.tags, var.elb_cert_tags)
  tg_tags     = merge(var.elb.tags, var.elb_tg_tags)
}