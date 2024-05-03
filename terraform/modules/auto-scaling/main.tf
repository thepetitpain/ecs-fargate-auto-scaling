resource "aws_appautoscaling_target" "ecs_as_target" {
  max_capacity       = var.as_target_max
  min_capacity       = var.as_target_min
  resource_id        = local.rsc_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_as_policies" {
  for_each           = { for policy in var.ecs_as_policies : policy.policy_name => policy }
  name               = each.value.policy_name
  policy_type        = each.value.policy_type
  resource_id        = aws_appautoscaling_target.ecs_as_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_as_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_as_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = each.value.metric
    }

    target_value = each.value.target_value
  }
}
