#-----------------------------
# SNS Module
#-----------------------------
module "tfsp_sns" {
  source                                    = "./localmodules/sns"
  envname                                   = var.env_name
  be_sns_topic_subscription_lambda_endpoint = module.tfsp_lambda.lambda_function_arn
}