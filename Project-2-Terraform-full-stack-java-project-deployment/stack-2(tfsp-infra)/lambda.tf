#-------------------------
# Lambda modiule
#-------------------------
module "tfsp_lambda" {
  source = "./localmodules/lambda"

  envname                          = var.env_name
  sns_topic_arn                    = module.tfsp_sns.sns_alert_topic_arn
  slack_web_hook_url               = var.slack_web_hook_url
  be_cloudwatch_lambda_memory_size = var.be_cloudwatch_lambda_memory_size
  be_cloudwatch_lambda_timeout     = var.be_cloudwatch_lambda_timeout
  be_cloudwatch_lambda_runtime     = var.be_cloudwatch_lambda_runtime
}