locals {
  ecs_service_td = templatefile(
    "${path.root}/files/ecs-services/task-definition.json.tftpl",
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
}