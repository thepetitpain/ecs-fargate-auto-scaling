resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_name}-cluster"
  setting {
    name  = "containerInsights"
    value = var.ecs_enable_insights ? local.insights_enabled : local.insights_disabled
  }

  tags = var.ecs_tags
}

resource "aws_ecs_task_definition" "ecs_td" {
  family = var.ecs_name
  container_definitions = var.ecs_td_definition != "" ? var.ecs_td_definition : templatefile(
    "${path.module}/files/task-definition.json.tftpl",
    {
      "port"        = var.ecs_td_definition_port
      "protocol"    = "${var.ecs_td_definition_protocol}"
      "cpu"         = var.ecs_td_cpu
      "mem"         = var.ecs_td_mem
      "env"         = var.ecs_td_definition_env
      "image"       = "${var.ecs_td_definition_image}"
      "name"        = "${var.container_svc_name}"
      "isessential" = var.ecs_td_isessential
    }
  )

  network_mode = local.network_mode
  requires_compatibilities = [
  local.platform]
  memory             = var.ecs_td_mem
  cpu                = var.ecs_td_cpu
  execution_role_arn = var.ecs_role.arn
  task_role_arn      = var.ecs_role.arn

  tags = var.ecs_tags
}

resource "aws_ecs_service" "ecs_service" {
  name             = "${var.ecs_name}-service"
  cluster          = aws_ecs_cluster.ecs_cluster.id
  task_definition  = aws_ecs_task_definition.ecs_td.arn
  desired_count    = var.svc_desired_count
  launch_type      = local.platform
  platform_version = local.platform_version

  lifecycle {
    ignore_changes = [desired_count]
  }

  network_configuration {
    subnets = var.ecs_subnets[*].id
    security_groups = [var.ecs_sg.id]
    assign_public_ip = var.enable_public_ip
  }

  load_balancer {
    target_group_arn = var.ecs_target_group.arn
    container_name   = var.container_svc_name
    container_port   = var.container_svc_port
  }
}
