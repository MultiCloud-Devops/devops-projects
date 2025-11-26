#------------------------
# CloudFront Module
#--------------------------
module "tfsp_cf" {
  source = "./localmodules/cloudfront"

  alb_dns                   = module.tfsp_alb.alb_dns
  envname                   = var.env_name
  cf_origin_id              = var.cf_origin_id
  cf_origin_protocol_policy = var.cf_origin_protocol_policy
  cf_origin_ssl_protocols   = var.cf_origin_ssl_protocols
  cf_allowed_methods        = var.cf_allowed_methods
  cf_cached_methods         = var.cf_cached_methods
  cf_forwarded_headers      = var.cf_forwarded_headers
  cf_viewer_protocol_policy = var.cf_viewer_protocol_policy
  cf_min_ttl                = var.cf_min_ttl
  cf_default_ttl            = var.cf_default_ttl
  cf_max_ttl                = var.cf_max_ttl
  acm_cert_arn              = module.tfsp_acm.acm_cert_arn
  r53_domain_name           = var.r53_domain_name
  route53_zoneid            = module.tfsp_acm.route53_zoneid
  web_acl_id                = module.tfsp_wfa.web_acl_id

  depends_on = [module.tfsp_acm]
}