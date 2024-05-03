resource "aws_ecr_repository" "ecr_registry" {
  name                 = var.registry_name
  image_tag_mutability = var.is_mutable ? local.mutable_enabled : local.mutable_disabled

  image_scanning_configuration {
    scan_on_push = var.enable_scanning
  }

  encryption_configuration {
    encryption_type = var.encryption_type
  }
  force_delete = true
  tags         = var.registry_tags
}
