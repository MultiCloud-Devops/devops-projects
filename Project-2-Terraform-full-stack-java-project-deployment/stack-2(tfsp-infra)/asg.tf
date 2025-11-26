#-----------------------------
# ASG for Application Servers
#-----------------------------
module "tfsp_asg" {
  source = "./localmodules/asg"

  envname                                 = var.env_name
  rds_db_end_point                        = module.tfsp_rds.rds_db_end_point
  rds_db_username                         = module.tfsp_rds.rds_db_username
  rds_db_password                         = module.tfsp_rds.rds_db_password
  be_infra_jar_file                       = var.be_infra_jar_file
  be_terraform_remote_state_bucket_region = var.be_terraform_remote_state_bucket_region
  be_terraform_remote_state_bucket        = var.be_terraform_remote_state_bucket
  vpc_id                                  = module.tfsp_vpc.vpc_id
  be_security_group_ingress               = var.be_security_group_ingress
  be_asg_instance_type                    = var.be_asg_instance_type
  be_asg_ami_id                           = var.be_asg_ami_id
  be_asg_target_group_arn                 = module.tfsp_nlb.nlb_be_tg_arn
  vpc_private_subnets                     = module.tfsp_vpc.vpc_private_subnets
  be_asg_desired_capacity                 = var.be_asg_desired_capacity
  be_asg_max_size                         = var.be_asg_max_size
  be_asg_min_size                         = var.be_asg_min_size
  be_asg_health_check_grace_period        = var.be_asg_health_check_grace_period
  be_asg_health_check_type                = var.be_asg_health_check_type
  subnet_id                               = module.tfsp_vpc.vpc_private_subnets[0]

  be_asg_scale_down_cron_expression  = var.be_asg_scale_down_cron_expression
  be_asg_scale_down_time_zone        = var.be_asg_scale_down_time_zone
  be_asg_scale_down_min_size         = var.be_asg_scale_down_min_size
  be_asg_scale_down_max_size         = var.be_asg_scale_down_max_size
  be_asg_scale_down_desired_capacity = var.be_asg_scale_down_desired_capacity

  be_asg_scale_up_cron_expression  = var.be_asg_scale_up_cron_expression
  be_asg_scale_up_time_zone        = var.be_asg_scale_up_time_zone
  be_asg_scale_up_min_size         = var.be_asg_scale_up_min_size
  be_asg_scale_up_max_size         = var.be_asg_scale_up_max_size
  be_asg_scale_up_desired_capacity = var.be_asg_scale_up_desired_capacity

  # asg-fe parameters
  nlb_dns_endpoint          = module.tfsp_nlb.nlb_dns_endpoint
  fe_security_group_ingress = var.fe_security_group_ingress
  fe_asg_instance_type      = var.fe_asg_instance_type
  fe_asg_ami_id             = var.fe_asg_ami_id

  fe_asg_target_group_arn          = module.tfsp_alb.alb_tg_arn
  fe_asg_desired_capacity          = var.fe_asg_desired_capacity
  fe_asg_max_size                  = var.fe_asg_max_size
  fe_asg_min_size                  = var.fe_asg_min_size
  fe_asg_health_check_grace_period = var.fe_asg_health_check_grace_period
  fe_asg_health_check_type         = var.fe_asg_health_check_type


  depends_on = [module.tfsp_vpc, module.tfsp_nlb]

}