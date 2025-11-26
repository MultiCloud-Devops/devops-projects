#------------------------------------------
# Web Application Firewall
#------------------------------------------
resource "aws_wafv2_web_acl" "tfsp_wafv2_web_acl" {
  name  = "tfsp-${var.envname}-wafv2-web-acl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  custom_response_body {
    key          = "tfsp-${var.envname}-blocked-html"
    content      = file("${path.module}/files/blocked.html")
    content_type = "TEXT_HTML"
  }

  rule {
    name     = "tfsp-${var.envname}-block-bad-countries"
    priority = 1

    statement {
      geo_match_statement {
        country_codes = var.waf_blocked_country_codes
      }
    }

    action {
      block {
        custom_response {
          response_code            = 403
          custom_response_body_key = "tfsp-${var.envname}-blocked-html"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "tfsp-${var.envname}-blockBadCountries"
      sampled_requests_enabled   = false
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "tfsp-${var.envname}-wafv2-web-acl-metric"
    sampled_requests_enabled   = false
  }
}
