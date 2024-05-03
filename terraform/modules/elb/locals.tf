locals {
  lb_tags        = merge(var.global_tags, var.elb_lb_tags)
  elb_isinternal = false
  elb_lb_type    = "application"
}