###### aws_ecs_task_definition #####
### Imports ###
variable "ecs_cluster" {}

variable "ecs_target_group" {}

variable "ecs_subnets" {}

variable "ecs_sg" {}

variable "ecs_role" {}

### ecs_td ###

variable "ecs_td_definition" {
  type    = string
  default = <<TD
    [
    {
        "portMappings": [
        {
            "hostPort": 80,
            "protocol": "tcp",
            "containerPort": 80
        }
        ],
        "cpu": 512,
        "environment": [
        {
            "name": "AUTHOR",
            "value": "Terraform"
        }
        ],
        "memory": 1024,
        "image": "dockersamples/static-site",
        "essential": true,
        "name": "site"
    }
    ]
  TD
}

variable "ecs_td_definition_port" {
  type    = number
  default = 80
}

variable "ecs_td_definition_env" {
  type = list(map(string))
  default = [
    {
      "name" : "AUTHOR",
      "value" : "Terraform"
    }
  ]
}

variable "ecs_td_isessential" {
  type    = bool
  default = true
}

variable "ecs_td_definition_protocol" {
  type    = string
  default = "tcp"
}

variable "ecs_td_definition_image" {
  type    = string
  default = "dockersamples/static-site"
}


variable "ecs_td_cpu" {
  type    = number
  default = 1024
}

variable "ecs_td_mem" {
  type    = number
  default = 1024
}

##### aws_ecs_service #####
### ecs_service ###

variable "svc_desired_count" {
  type    = number
  default = 1
}

variable "enable_public_ip" {
  type    = bool
  default = true
}

variable "container_svc_name" {
  type    = string
  default = "my-container"
}

variable "container_svc_port" {
  type    = number
  default = 80
}