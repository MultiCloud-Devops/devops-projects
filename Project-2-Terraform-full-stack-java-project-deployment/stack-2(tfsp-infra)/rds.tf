#-------------------------
# RDS Module
#------------------------------
module "tfsp_rds" {
  source = "./localmodules/rds"

  envname                    = var.env_name
  vpc_private_subnets        = module.tfsp_vpc.vpc_private_subnets
  vpc_id                     = module.tfsp_vpc.vpc_id
  rds_security_group_ingress = var.rds_security_group_ingress
  db_password_parameter_name = var.db_password_parameter_name
  db_username_parameter_name = var.db_username_parameter_name
  rds_db_engine              = var.rds_db_engine
  rds_db_engine_version      = var.rds_db_engine_version
  rds_db_instance_class      = var.rds_db_instance_class
  rds_db_allocated_storage   = var.rds_db_allocated_storage

  depends_on = [module.tfsp_vpc]
}