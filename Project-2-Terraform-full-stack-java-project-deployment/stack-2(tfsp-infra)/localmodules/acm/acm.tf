#---------------------------------------
# ACM Certificate Including subdomains
#---------------------------------------
resource "aws_acm_certificate" "tfsp_acm" {
  domain_name               = var.r53_domain_name
  subject_alternative_names = ["*.${var.r53_domain_name}"]
  validation_method         = "DNS"
}

#-----------------------------------------
# Route53 records
#-----------------------------------------
data "aws_route53_zone" "tfsp_ruote53_zone" {
  name         = var.r53_domain_name
  private_zone = false
}

#-------------------------------------------
# Route53 Certifiate record
#-------------------------------------------
resource "aws_route53_record" "tfsp_route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.tfsp_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.tfsp_ruote53_zone.zone_id
}

#-------------------------------------------
# R53 ACM Certificate Validation
#-------------------------------------------
resource "aws_acm_certificate_validation" "tfsp_acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.tfsp_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.tfsp_route53_record : record.fqdn]
}
 