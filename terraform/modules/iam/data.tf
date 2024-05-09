data "aws_iam_policy_document" "ecs_service_elb" {
  statement {
    effect = var.iam_policy_doc_elb_desc_statement.effect[0]

    actions = var.iam_policy_doc_elb_desc_statement.actions

    resources = var.iam_policy_doc_elb_desc_statement.resources
  }

  statement {
    effect = var.iam_policy_doc_elb_mng_statement.effect[0]

    actions = var.iam_policy_doc_elb_mng_statement.actions

    resources = [
      var.elb.arn
    ]
  }
}

# data "aws_iam_policy" "ecs_service_ecr" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

#   # statement {
#   #   effect = local.iam_policy_doc_ecs_ecr.effect[0]

#   #   actions = local.iam_policy_doc_ecs_ecr.actions

#   #   resources = local.iam_policy_doc_ecs_ecr.resources
#   # }
# }

data "aws_iam_policy_document" "ecs_service_standard" {

  statement {
    effect = var.iam_policy_doc_ecs_std.effect[0]

    actions = var.iam_policy_doc_ecs_std.actions

    resources = var.iam_policy_doc_ecs_std.resources
  }
}

data "aws_iam_policy_document" "ecs_service_scaling" {

  statement {
    effect = var.iam_policy_doc_ecs_scaling.effect[0]

    actions = var.iam_policy_doc_ecs_scaling.actions

    resources = var.iam_policy_doc_ecs_scaling.resources
  }
}