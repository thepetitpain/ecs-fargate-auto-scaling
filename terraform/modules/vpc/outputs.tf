output "vpc" {
  value = aws_vpc.vpc
}

output "vpc_lb_subnets" {
  value = aws_subnet.elb_subnets
}

output "vpc_ecs_subnets" {
  value = aws_subnet.ecs_subnets
}

output "load_balancer_sg" {
  value = aws_security_group.load_balancer
}

output "ecs_sg" {
  value = aws_security_group.ecs_task
}
