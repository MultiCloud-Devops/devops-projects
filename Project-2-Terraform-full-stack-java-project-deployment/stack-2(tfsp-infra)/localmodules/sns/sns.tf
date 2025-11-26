#------------------------------------------
# SNS Module
#------------------------------------------
resource "aws_sns_topic" "tfsp_be_sns_topic" {
  name = "tfsp-${var.envname}-be-sns-alert-topic"

}

#------------------------------------------
# SNS Topic Subscription    
#------------------------------------------
resource "aws_sns_topic_subscription" "tfsp_be_sns_topic_subscription" {
  topic_arn = aws_sns_topic.tfsp_be_sns_topic.arn
  protocol  = "lambda"
  endpoint  = var.be_sns_topic_subscription_lambda_endpoint
}