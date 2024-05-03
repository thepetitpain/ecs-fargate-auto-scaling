provider "aws" {
  region = var.region
}

module "vpc" {
  source                              = "./modules/vpc"
  vpc_global_tags                     = var.vpc_global_tags
  vpc_main_cidr                       = var.vpc_main_cidr
  vpc_enable_dns                      = var.vpc_enable_dns
  vpc_dns_hn                          = var.vpc_dns_hn
  vpc_tags                            = var.vpc_tags
  vpc_igw_tags                        = var.vpc_igw_tags
  vpc_outside_route_table_cidr        = var.vpc_outside_route_table_cidr
  vpc_outside_route_table_tags        = var.vpc_outside_route_table_tags
  vpc_subnets_avail_bits              = var.vpc_subnets_avail_bits
  vpc_map_public_ips                  = var.vpc_map_public_ips
  vpc_subnets_tags                    = var.vpc_subnets_tags
  vpc_ecs_subnets_prefix              = var.vpc_ecs_subnets_prefix
  vpc_elb_subnets_prefix              = var.vpc_elb_subnets_prefix
  vpc_sg_lb_tags                      = var.vpc_sg_lb_tags
  vpc_sg_ecs_tags                     = var.vpc_sg_ecs_tags
  vpc_additional_ingress_egress_cidrs = var.vpc_additional_ingress_egress_cidrs
  vpc_sg_protocol                     = var.vpc_sg_protocol
  vpc_ecs_port                        = var.vpc_ecs_port
}

module "elb" {
  source                = "./modules/elb"
  load_balancer_sg      = module.vpc.load_balancer_sg
  load_balancer_subnets = module.vpc.vpc_lb_subnets
}

module "elb-target" {
  source                    = "./modules/elb-target"
  elb                       = module.elb.elb
  vpc                       = module.vpc.vpc
  elb_target_zone           = var.elb_target_zone
  elb_cert_target_subdomain = var.elb_cert_target_subdomain
}

module "iam" {
  source                      = "./modules/iam"
  elb                         = module.elb.elb
  iam_ecs_svc_name            = var.iam_ecs_svc_name
  iam_ecs_svc_role_policy     = file("${path.root}${var.iam_ecs_svc_role_policy}")
  iam_policy_elb_name         = var.iam_policy_elb_name
  iam_policy_ecs_std_name     = var.iam_policy_ecs_std_name
  iam_policy_ecs_scaling_name = var.iam_policy_ecs_scaling_name
}

module "ecr" {
  source          = "./modules/ecr"
  registry_name   = var.registry_name
  is_mutable      = var.is_mutable
  encryption_type = var.encryption_type
  registry_tags   = var.registry_tags
}

module "ecs" {
  source              = "./modules/ecs"
  ecs_name            = var.ecs_name
  ecs_enable_insights = var.ecs_enable_insights
  ecs_tags            = var.ecs_tags
}

module "ecs-services" {
  source                     = "./modules/ecs-services"
  ecs_cluster                = module.ecs.ecs_cluster
  ecs_role                   = module.iam.ecs_role
  ecs_sg                     = module.vpc.ecs_sg
  ecs_subnets                = module.vpc.vpc_ecs_subnets
  ecs_target_group           = module.elb-target.ecs_target_group
  ecs_td_definition          = local.ecs_service_td
  # ecs_td_definition_port     = var.ecs_td_definition_port
  # ecs_td_definition_env      = var.ecs_td_definition_env
  # ecs_td_isessential         = var.ecs_td_isessential
  # ecs_td_definition_protocol = var.ecs_td_definition_protocol
  # ecs_td_definition_image    = var.ecs_td_definition_image
  ecs_td_cpu                 = var.ecs_td_cpu
  ecs_td_mem                 = var.ecs_td_mem
  svc_desired_count          = var.svc_desired_count
  enable_public_ip           = var.enable_public_ip
  container_svc_name         = var.container_svc_name
  container_svc_port         = var.container_svc_port
}

module "auto_scaling" {
  source          = "./modules/auto-scaling"
  ecs_cluster     = module.ecs.ecs_cluster
  ecs_service     = module.ecs-services.ecs_service
  as_target_min   = var.as_target_min
  as_target_max   = var.as_target_max
  ecs_as_policies = var.ecs_as_policies
}

module "route53" {
  source           = "./modules/route53"
  elb              = module.elb.elb
  r53_zone         = var.elb_target_zone
  r53_subdomain    = var.elb_cert_target_subdomain
  r53_record_type  = var.r53_record_type
  r53_health_check = var.r53_health_check
}
