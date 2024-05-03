variable "load_balancer_sg" {}

variable "load_balancer_subnets" {}

##### aws_elb #####
variable "elb_lb_name" {
  type    = string
  default = "my-elb"
}

variable "elb_lb_tags" {
  type = map(string)
  default = {
    "name" = "my-load-balancer"
  }
}

variable "global_tags" {
  type = map(string)
  default = {
    Project = "my-project"
    Billing = "my-project"
  }
}
