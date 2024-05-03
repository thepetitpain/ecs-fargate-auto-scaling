resource "aws_iam_role" "ecs_service" {
  name = var.iam_ecs_svc_name

  assume_role_policy = var.iam_ecs_svc_role_policy
}

resource "aws_iam_policy" "ecs_service_elb" {
  name        = var.iam_policy_elb_name
  path        = var.iam_policy_elb_path
  description = var.iam_policy_elb_desc

  policy = data.aws_iam_policy_document.ecs_service_elb.json
}

resource "aws_iam_policy" "ecs_service_standard" {
  name        = var.iam_policy_ecs_std_name
  path        = var.iam_policy_ecs_std_path
  description = var.iam_policy_ecs_std_desc

  policy = data.aws_iam_policy_document.ecs_service_standard.json
}

resource "aws_iam_policy" "ecs_service_scaling" {
  name        = var.iam_policy_ecs_scaling_name
  path        = var.iam_policy_ecs_scaling_path
  description = var.iam_policy_ecs_scaling_desc

  policy = data.aws_iam_policy_document.ecs_service_scaling.json
}

resource "aws_iam_role_policy_attachment" "ecs_service_elb" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_elb.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_standard" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_standard.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_scaling" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_scaling.arn
}
