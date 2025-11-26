output "nlb_be_tg_arn" {
  value = aws_lb_target_group.tfsp_nlb_tg.arn
}

output "nlb_dns_endpoint" {
  value = aws_lb.tfsp_nlb.dns_name
}