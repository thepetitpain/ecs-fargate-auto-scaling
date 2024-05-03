locals {
  vpc_tags         = merge(var.vpc_global_tags, var.vpc_tags)
  igw_tags         = merge(var.vpc_global_tags, var.vpc_igw_tags)
  route_table_tags = merge(var.vpc_global_tags, var.vpc_outside_route_table_tags)
  sg_lb_tags       = merge(var.vpc_global_tags, var.vpc_sg_lb_tags)
  sg_ecs_tags      = merge(var.vpc_global_tags, var.vpc_sg_ecs_tags)
  http-s_ports     = [80, 443]
  egress_port      = 65535
  io_cidrs         = concat(["${var.vpc_outside_route_table_cidr}"], var.vpc_additional_ingress_egress_cidrs)
  acl_rules_in_groups = [
    [1024, local.egress_port],
    [local.http-s_ports[0], local.http-s_ports[0]],
    [local.http-s_ports[1], local.http-s_ports[1]]
  ]
}