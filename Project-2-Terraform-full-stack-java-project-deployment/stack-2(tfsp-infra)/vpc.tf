#--------------------------------------
# VPC - Module
#--------------------------------------
module "tfsp_vpc" {
  source = "./localmodules/vpc"

  vpc_cidr_block = var.vpc_cidr_block
  env_name       = var.env_name
}