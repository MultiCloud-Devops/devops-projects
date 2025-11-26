#----------------------------
# WebAcL module
#----------------------------
module "tfsp_wfa" {
  source = "./localmodules/waf"

  envname                   = var.env_name
  waf_blocked_country_codes = var.waf_blocked_country_codes
}