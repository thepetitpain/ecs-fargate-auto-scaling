resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_name}-cluster"
  setting {
    name  = "containerInsights"
    value = var.ecs_enable_insights ? local.insights_enabled : local.insights_disabled
  }

  tags = var.ecs_tags
}

