#---------------------------------------
# Application Load Balancer Module
#---------------------------------------
module "tfsp_alb" {

  source = "./localmodules/alb"

  envname                    = var.env_name
  vpc_id                     = module.tfsp_vpc.vpc_id
  alb_security_group_ingress = var.alb_security_group_ingress
  vpc_public_subnets         = module.tfsp_vpc.vpc_public_subnets

}