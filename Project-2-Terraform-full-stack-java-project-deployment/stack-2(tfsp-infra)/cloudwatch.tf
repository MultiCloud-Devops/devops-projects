#-------------------------------
# CloudWatch Module
#-------------------------------
module "tfsp_cloudwatch" {
  source = "./localmodules/cloudwatch"

  envname                      = var.env_name
  be_cloudwatch_log_group_name = var.be_cloudwatch_log_group_name
  sns_topic_arn                = module.tfsp_sns.sns_alert_topic_arn
}