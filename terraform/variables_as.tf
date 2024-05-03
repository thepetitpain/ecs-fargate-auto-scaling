variable "as_target_min" {
  type    = number
  default = 1
}

variable "as_target_max" {
  type    = number
  default = 3
}

variable "ecs_as_policies" {
  type = list(object({
    policy_name  = string
    policy_type  = string
    metric       = string
    target_value = number
  }))
  default = [{
    policy_name  = "ecs-default-as-policy"
    policy_type  = "TargetTrackingScaling"
    metric       = "ECSServiceAverageCPUUtilization"
    target_value = 75
  }]
}
