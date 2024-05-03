
variable "iam_ecs_svc_name" {
  type    = string
  default = "my-ecs-service-role"
}

variable "iam_ecs_svc_role_policy" {
  type    = string
  default = "{}"
}

variable "iam_policy_doc_elb_desc_statement" {
  type = map(list(string))
  default = {
    effect    = ["Allow"]
    actions   = ["ec2:Describe"]
    resources = ["*"]
  }
}

variable "iam_policy_doc_elb_mng_statement" {
  type = map(list(string))
  default = {
    effect = ["Allow"]
    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]
  }
}

variable "iam_policy_doc_ecs_std" {
  type = map(list(string))
  default = {
    effect = ["Allow"]
    actions = [
      "ec2:DescribeTags",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

variable "iam_policy_doc_ecs_scaling" {
  type = map(list(string))
  default = {
    effect = ["Allow"]
    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]
    resources = ["*"]
  }
}

variable "iam_policy_elb_name" {
  type    = string
  default = "my-elb-policy"
}

variable "iam_policy_elb_path" {
  type    = string
  default = "/"
}

variable "iam_policy_elb_desc" {
  type    = string
  default = "Allow access to the service elb"
}

variable "iam_policy_ecs_std_name" {
  type    = string
  default = "my-ecs-std-policy"
}

variable "iam_policy_ecs_std_path" {
  type    = string
  default = "/"
}

variable "iam_policy_ecs_std_desc" {
  type    = string
  default = "Allow standard ecs actions"
}

variable "iam_policy_ecs_scaling_name" {
  type    = string
  default = "my-ecs-scaling-policy"
}

variable "iam_policy_ecs_scaling_path" {
  type    = string
  default = "/"
}

variable "iam_policy_ecs_scaling_desc" {
  type    = string
  default = "Allow ecs scaling"
}