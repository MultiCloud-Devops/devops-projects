output "acm_cert_arn" {
  value = aws_acm_certificate.tfsp_acm.arn
}

output "route53_zoneid" {
  value = data.aws_route53_zone.tfsp_ruote53_zone.zone_id
}