variable "envname" {
  type    = string
  default = ""
}

variable "slack_web_hook_url" {
  type    = string
  default = ""
}

variable "sns_topic_arn" {
  type    = string
  default = ""
}

variable "be_cloudwatch_lambda_timeout" {
  type    = number
  default = 0
}
variable "be_cloudwatch_lambda_memory_size" {
  type    = number
  default = 0
}
variable "be_cloudwatch_lambda_runtime" {
  type    = string
  default = ""
}