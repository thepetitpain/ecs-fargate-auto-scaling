resource "aws_route53_record" "dev_to" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.r53_subdomain}.${data.aws_route53_zone.selected.name}"
  type    = var.r53_record_type

  alias {
    name                   = var.elb.dns_name
    zone_id                = var.elb.zone_id
    evaluate_target_health = var.r53_health_check
  }
}
