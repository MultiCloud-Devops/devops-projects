#-----------------------
# SNS Outputs
#-----------------------
output "sns_alert_topic_arn" {
  value = aws_sns_topic.tfsp_be_sns_topic.arn
}