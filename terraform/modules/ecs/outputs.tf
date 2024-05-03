output "ecs_cluster" {
  value = aws_ecs_cluster.ecs_cluster
}

output "ecs_service" {
  value = aws_ecs_service.ecs_service
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.ecs_td
}