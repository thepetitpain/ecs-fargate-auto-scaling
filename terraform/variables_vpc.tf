variable "vpc_global_tags" {
  type = map(string)
  default = {
    project = "my-project"
  }
}


##### VPC #####
variable "vpc_main_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "vpc_enable_dns" {
  type    = bool
  default = true
}

variable "vpc_dns_hn" {
  type    = bool
  default = true
}

variable "vpc_tags" {
  type = map(string)
  default = {
    name = "my-vpc"
  }
}

##### IGW #####
variable "vpc_igw_tags" {
  type = map(string)
  default = {
    name    = "my-igw"
    billing = "my-project"
  }
}

##### Route Table #####
variable "vpc_outside_route_table_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vpc_outside_route_table_tags" {
  type = map(string)
  default = {
    name = "my-route-table"
  }
}

variable "vpc_subnets_avail_bits" {
  type    = number
  default = 8
}

variable "vpc_map_public_ips" {
  type    = bool
  default = true
}

variable "vpc_subnets_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_elb_subnets_prefix" {
  type    = string
  default = "my-elb-subnet"
}

variable "vpc_ecs_subnets_prefix" {
  type    = string
  default = "my-ecs-subnet"
}

##### SGs #####
variable "vpc_sg_lb_tags" {
  type = map(string)
  default = {
    name = "my-elb-security-group"
  }
}

variable "vpc_sg_ecs_tags" {
  type = map(string)
  default = {
    name = "my-ecs-security-group"
  }
}

##### SG Rules #####
variable "vpc_additional_ingress_egress_cidrs" {
  type    = list(string)
  default = []
}

variable "vpc_sg_protocol" {
  type    = string
  default = "tcp"
}

variable "vpc_ecs_port" {
  type    = number
  default = 80
}