#--------------------------
# CloudFront
#-------------------------
resource "aws_cloudfront_distribution" "tfsp_cf_distribution" {
  origin {
    domain_name = var.alb_dns
    origin_id   = var.cf_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = var.cf_origin_protocol_policy
      origin_ssl_protocols   = var.cf_origin_ssl_protocols
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ALB (HTTP only)"
  default_root_object = "index.html"
  web_acl_id          = var.web_acl_id
  default_cache_behavior {
    allowed_methods  = var.cf_allowed_methods
    cached_methods   = var.cf_cached_methods
    target_origin_id = var.cf_origin_id

    forwarded_values {
      query_string = true
      headers      = var.cf_forwarded_headers
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = var.cf_viewer_protocol_policy
    min_ttl                = var.cf_min_ttl
    default_ttl            = var.cf_default_ttl
    max_ttl                = var.cf_max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases     = ["datastore.${var.r53_domain_name}"]
  price_class = "PriceClass_100"
  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn      = var.acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = "tfsp-${var.envname}-cf"
  }
}

#-------------------------------------
# Route53 alias record for CloudFront
#-------------------------------------
resource "aws_route53_record" "tfsp_route53_cf_alias_record" {
  zone_id = var.route53_zoneid
  name    = "datastore.${var.r53_domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.tfsp_cf_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.tfsp_cf_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

 