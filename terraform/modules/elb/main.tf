resource "aws_lb" "elb" {
  name               = var.elb_lb_name
  internal           = local.elb_isinternal
  load_balancer_type = local.elb_lb_type
  security_groups    = [var.load_balancer_sg.id]
  subnets            = var.load_balancer_subnets[*].id

  tags = local.lb_tags
}