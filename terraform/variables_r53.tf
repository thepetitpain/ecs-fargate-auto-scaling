variable "r53_zone" {
  type    = string
  default = "exemple.net"
}

variable "r53_subdomain" {
  type    = string
  default = "site"
}

variable "r53_record_type" {
  type    = string
  default = "A"
}

variable "r53_health_check" {
  type    = bool
  default = true
}