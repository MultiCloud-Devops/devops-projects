#-----------------------
# Network Load Balancer
#-----------------------
module "tfsp_nlb" {

  source = "./localmodules/nlb"

  envname                    = var.env_name
  vpc_id                     = module.tfsp_vpc.vpc_id
  nlb_security_group_ingress = var.nlb_security_group_ingress
  vpc_private_subnets        = module.tfsp_vpc.vpc_private_subnets

}