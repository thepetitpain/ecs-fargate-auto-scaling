##### main #####


##### Auto-Scaling ######
as_target_min = 1
as_target_max = 5
ecs_as_policies = [{
  policy_name  = "ecs-cpu-as-policy"
  policy_type  = "TargetTrackingScaling"
  metric       = "ECSServiceAverageCPUUtilization"
  target_value = 75
  },
  {
    policy_name  = "ecs-mem-as-policy"
    policy_type  = "TargetTrackingScaling"
    metric       = "ECSServiceAverageMemoryUtilization"
    target_value = 80
}]

##### ECR #####
registry_name   = "exemple-demos-registry"
is_mutable      = true
enable_scanning = true
encryption_type = "KMS"
registry_tags = {
  "name" = "exemple-demos-registry"
}

##### ECS #####
ecs_name            = "exemple-demos-ecs"
ecs_enable_insights = true
ecs_tags = {
  Name    = "exemple-demos-ecs"
  Project = "exemple-demos"
  Billing = "exemple-demos-ecs"
}
ecs_td_definition_port     = 80
ecs_td_definition_protocol = "tcp"
ecs_td_definition          = ""
ecs_td_cpu                 = 1024
ecs_td_mem                 = 2048
svc_desired_count          = 1
enable_public_ip           = true
container_svc_name         = "exemple-demos-container"
container_svc_port         = 80
ecs_td_isessential         = true

##### ELB #####
elb_target_zone                  = "exemple.net"
elb_cert_target_subdomain        = "exemple-subdomain"
elb_cert_validation_method       = "DNS"
elb_cert_tags                    = {}
elb_allow_dns_overwrite          = true
elb_dns_record_ttl               = 60
elb_lb_name                      = "exemple-demos-elb"
elb_lb_tags                      = { "name" = "exemple-demos-lb" }
elb_tg_name                      = "exemple-demo-target-group"
elb_tg_port                      = 80
elb_tg_protocol                  = "HTTP"
elb_tg_target_type               = "ip"
elb_tg_hc_enable                 = true
elb_tg_hc_interval               = 300
elb_tg_hc_path                   = "/"
elb_tg_hc_timeout                = 60
elb_tg_hc_match                  = "200"
elb_tg_hc_healthy                = 5
elb_tg_hc_unhealthy              = 5
elb_tg_tags                      = { "Name" = "exemple-demo-target-group" }
elb_listener_port                = 443
elb_listener_protocol            = "HTTPS"
elb_listener_ssl_policy          = "ELBSecurityPolicy-2016-08"
elb_listener_redirector_port     = 80
elb_listener_redirector_protocol = "HTTP"

##### IAM #####
iam_ecs_svc_name        = "exemple-demos-iam-ecs-svc-role"
iam_ecs_svc_role_policy = "\\files\\iam\\iam-ecs-svc-role.json"
# iam_policy_doc_elb_desc_statement = {}
# iam_policy_doc_elb_iam_policy_doc_elb_mng_statement = {}
# iam_policy_doc_ecs_std = {}
# iam_policy_doc_ecs_scaling = {}
iam_policy_elb_name = "exemple-demos-elb-policy"
# iam_policy_ecs_std_path = "/"
iam_policy_ecs_std_name = "exemple-demos-ecs-standard-policy"
# iam_policy_ecs_std_path = "/"
iam_policy_ecs_scaling_name = "exemple-demos-ecs-scaling-policy"

##### Route53 #####
r53_record_type  = "A"
r53_health_check = true

##### VPC #####
vpc_global_tags = { Project = "exemple-demos" }
vpc_main_cidr   = "172.32.0.0/16"
vpc_tags        = { Name = "exemple-demos-vpc" }
vpc_igw_tags = {
  Name    = "exemple-demos-igw"
  Billing = "exemple-demos"
}
vpc_outside_route_table_tags = { Name = "exemple-demos-route-table" }
vpc_elb_subnets_prefix       = "exemple-demos-elb-subnet"
vpc_ecs_subnets_prefix       = "exemple-demos-ecs-subnet"
vpc_sg_lb_tags               = { Name = "exemple-demos-elb-sg" }
vpc_sg_ecs_tags              = { Name = "exemple-demos-ecs-sg" }
