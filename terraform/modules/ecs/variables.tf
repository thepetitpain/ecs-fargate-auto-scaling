##### aws_ecs_cluster #####
### ecs_cluster ###

variable "ecs_name" {
  type    = string
  default = "my-ecs-cluster"
}

variable "ecs_enable_insights" {
  type    = bool
  default = true
}

variable "ecs_tags" {
  type = map(string)
  default = {
    "Name" = "my-ecs-cluster"
  }
}

