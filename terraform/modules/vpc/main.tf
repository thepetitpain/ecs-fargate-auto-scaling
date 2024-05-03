resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_main_cidr
  enable_dns_support   = var.vpc_enable_dns
  enable_dns_hostnames = var.vpc_dns_hn

  tags = local.vpc_tags
}

resource "aws_internet_gateway" "internal_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.igw_tags
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.vpc_outside_route_table_cidr
    gateway_id = aws_internet_gateway.internal_gateway.id
  }

  tags = local.route_table_tags
}

/* The goal is to always create multiple subnets, allowing for HA accross 
the whole region of the vpc */
resource "aws_subnet" "elb_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.vpc_subnets_avail_bits, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.vpc_map_public_ips
  tags                    = merge(var.vpc_global_tags, var.vpc_subnets_tags, { name = "${var.vpc_elb_subnets_prefix}-${data.aws_availability_zones.available.names[count.index]}" })
}

resource "aws_subnet" "ecs_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.vpc_subnets_avail_bits, length(aws_subnet.elb_subnets) + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.vpc_map_public_ips
  tags                    = merge(var.vpc_global_tags, var.vpc_subnets_tags, { name = "${var.vpc_ecs_subnets_prefix}-${data.aws_availability_zones.available.names[count.index]}" })
}

resource "aws_route_table_association" "elb_rt_associations" {
  count          = length(aws_subnet.elb_subnets)
  subnet_id      = aws_subnet.elb_subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "ecs_rt_associations" {
  count          = length(aws_subnet.ecs_subnets)
  subnet_id      = aws_subnet.ecs_subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "load_balancer" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.sg_lb_tags
}

resource "aws_security_group" "ecs_task" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.sg_ecs_tags
}

resource "aws_security_group_rule" "http-s_ingress_security_groups" {
  for_each          = { for port in local.http-s_ports : port => port }
  from_port         = each.value
  protocol          = var.vpc_sg_protocol
  security_group_id = aws_security_group.load_balancer.id
  to_port           = each.value
  cidr_blocks       = local.io_cidrs
  type              = "ingress"
}

resource "aws_security_group_rule" "ingress_ecs_task_elb" {
  from_port                = var.vpc_ecs_port
  protocol                 = var.vpc_sg_protocol
  security_group_id        = aws_security_group.ecs_task.id
  to_port                  = var.vpc_ecs_port
  source_security_group_id = aws_security_group.load_balancer.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "egress_load_balancer" {
  type              = "egress"
  from_port         = 0
  to_port           = local.egress_port
  protocol          = var.vpc_sg_protocol
  cidr_blocks       = local.io_cidrs
  security_group_id = aws_security_group.load_balancer.id
}

resource "aws_security_group_rule" "egress_ecs_task" {
  type              = "egress"
  from_port         = 0
  to_port           = local.egress_port
  protocol          = var.vpc_sg_protocol
  cidr_blocks       = local.io_cidrs
  security_group_id = aws_security_group.ecs_task.id
}

resource "aws_network_acl" "load_balancer" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = aws_subnet.elb_subnets[*].id
}

resource "aws_network_acl" "ecs_task" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = aws_subnet.ecs_subnets[*].id
}

resource "aws_network_acl_rule" "ingress_elb_acl_rules" {
  count          = length(local.acl_rules_in_groups)
  network_acl_id = aws_network_acl.load_balancer.id
  rule_number    = (count.index + 1) * 100
  egress         = false
  protocol       = var.vpc_sg_protocol
  rule_action    = "allow"
  cidr_block     = var.vpc_outside_route_table_cidr
  from_port      = local.acl_rules_in_groups[count.index][0]
  to_port        = local.acl_rules_in_groups[count.index][1]
}

resource "aws_network_acl_rule" "ingress_ecs_tasks" {
  count          = length(local.acl_rules_in_groups)
  network_acl_id = aws_network_acl.ecs_task.id
  rule_number    = (count.index +1 ) * 100
  egress         = false
  protocol       = var.vpc_sg_protocol
  rule_action    = "allow"
  cidr_block     = local.acl_rules_in_groups[count.index][0] != local.http-s_ports[0] ? var.vpc_outside_route_table_cidr : aws_vpc.vpc.cidr_block
  from_port      = local.acl_rules_in_groups[count.index][0]
  to_port        = local.acl_rules_in_groups[count.index][1]
}

resource "aws_network_acl_rule" "load_balancer_ephemeral" {
  network_acl_id = aws_network_acl.load_balancer.id
  rule_number    = 100
  egress         = true
  protocol       = var.vpc_sg_protocol
  rule_action    = "allow"
  from_port      = 0
  to_port        = local.egress_port
  cidr_block     = var.vpc_outside_route_table_cidr
}

resource "aws_network_acl_rule" "ecs_task_all" {
  network_acl_id = aws_network_acl.ecs_task.id
  rule_number    = 100
  egress         = true
  protocol       = var.vpc_sg_protocol
  rule_action    = "allow"
  from_port      = 0
  to_port        = local.egress_port
  cidr_block     = var.vpc_outside_route_table_cidr
}
