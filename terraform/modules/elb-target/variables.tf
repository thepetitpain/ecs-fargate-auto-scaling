##### From other modules #####
variable "vpc" {}

variable "elb" {}

##### aws_route53_zone - data #####
variable "elb_target_zone" {
  type    = string
  default = "exemple.net"
}


###### aws_acm_certificate #####
variable "elb_cert_target_subdomain" {
  type    = string
  default = "domain"
}

variable "elb_cert_validation_method" {
  type        = string
  default     = "DNS"
  description = "Can either be DNS or EMAIL"
}

variable "elb_cert_tags" {
  type    = map(string)
  default = {}
}

##### aws_route53_record ######
variable "elb_allow_dns_overwrite" {
  type    = bool
  default = true
}

variable "elb_dns_record_ttl" {
  type    = number
  default = 60
}

###### aws_lb_target_group #####
variable "elb_tg_name" {
  type    = string
  default = "my-target-group"
}

variable "elb_tg_port" {
  type    = number
  default = 80
}

variable "elb_tg_protocol" {
  type    = string
  default = "HTTP"
}

variable "elb_tg_target_type" {
  type    = string
  default = "ip"
}

variable "elb_tg_hc_enable" {
  type    = bool
  default = true
}

variable "elb_tg_hc_interval" {
  type    = number
  default = 300
}

variable "elb_tg_hc_path" {
  type    = string
  default = "/"
}

variable "elb_tg_hc_timeout" {
  type    = number
  default = 60
}

variable "elb_tg_hc_match" {
  type    = string
  default = "200"
}

variable "elb_tg_hc_healthy" {
  type    = number
  default = 5
}

variable "elb_tg_hc_unhealthy" {
  type    = number
  default = 5
}

variable "elb_tg_tags" {
  type = map(string)
  default = {
    "name" = "my-target-group"
  }
}

#####aws_lb_listener #####
variable "elb_listener_port" {
  type    = number
  default = 443
}

variable "elb_listener_protocol" {
  type    = string
  default = "HTTPS"
}

variable "elb_listener_ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "elb_listener_redirector_port" {
  type    = number
  default = 80
}

variable "elb_listener_redirector_protocol" {
  type    = string
  default = "HTTP"
}