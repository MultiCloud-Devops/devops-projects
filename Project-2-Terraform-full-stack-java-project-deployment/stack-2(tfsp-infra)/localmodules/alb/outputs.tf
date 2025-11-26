output "alb_tg_arn" {
  value = aws_lb_target_group.tfsp_alb_tg.arn
}

output "alb_dns" {
  value = aws_lb.tfsp_alb.dns_name
}