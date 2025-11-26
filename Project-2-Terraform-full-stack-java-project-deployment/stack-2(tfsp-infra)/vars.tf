variable "env_name" {
  type    = string
  default = ""
}
variable "vpc_cidr_block" {
  type    = string
  default = ""
}

variable "rds_security_group_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "db_password_parameter_name" {
  type    = string
  default = ""
}

variable "rds_db_engine" {
  type    = string
  default = ""
}

variable "rds_db_engine_version" {
  type    = string
  default = ""
}

variable "rds_db_instance_class" {
  type    = string
  default = ""
}

variable "db_username_parameter_name" {
  type    = string
  default = ""
}

variable "rds_db_allocated_storage" {
  type    = number
  default = 0
}


#-------------------------------
# NLB Variables
#------------------------------
variable "nlb_security_group_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "be_infra_jar_file" {
  type    = string
  default = ""
}

variable "be_terraform_remote_state_bucket" {
  type    = string
  default = ""
}

variable "be_terraform_remote_state_bucket_region" {
  type    = string
  default = ""
}

#-------------------------------
# ASG Variables 
#------------------------------
variable "be_security_group_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

}

variable "be_asg_ami_id" {
  type    = string
  default = ""
}

variable "be_asg_instance_type" {
  type    = string
  default = ""
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = [""]
}

variable "be_asg_desired_capacity" {
  type    = number
  default = 0
}
variable "be_asg_max_size" {
  type    = number
  default = 0
}

variable "be_asg_min_size" {
  type    = number
  default = 0
}
variable "be_asg_health_check_grace_period" {
  type    = number
  default = 0
}

variable "be_asg_health_check_type" {
  type    = string
  default = ""
}


variable "be_asg_scale_up_min_size" {
  type    = number
  default = 0
}
variable "be_asg_scale_up_max_size" {
  type    = number
  default = 0
}
variable "be_asg_scale_up_desired_capacity" {
  type    = number
  default = 0
}
variable "be_asg_scale_up_time_zone" {
  type    = string
  default = ""
}
variable "be_asg_scale_up_cron_expression" {
  type    = string
  default = ""
}
variable "be_asg_scale_down_min_size" {
  type    = number
  default = 0
}
variable "be_asg_scale_down_max_size" {
  type    = number
  default = 0
}
variable "be_asg_scale_down_desired_capacity" {
  type    = number
  default = 0
}
variable "be_asg_scale_down_time_zone" {
  type    = string
  default = ""
}
variable "be_asg_scale_down_cron_expression" {
  type    = string
  default = ""
}

#-----------------------------
# ClowdWatch Variables
#-----------------------------
variable "be_cloudwatch_log_group_name" {
  type    = string
  default = ""
}

#-----------------------------
# Lambda Slack Webhook URL Variable
#-----------------------------
variable "slack_web_hook_url" {
  type    = string
  default = ""
}

variable "be_cloudwatch_lambda_memory_size" {
  type    = number
  default = 0
}
variable "be_cloudwatch_lambda_runtime" {
  type    = string
  default = ""
}
variable "be_cloudwatch_lambda_timeout" {
  type    = number
  default = 0
}


#-----------------------------
# FE ASG Variables
#-----------------------------
variable "fe_asg_ami_id" {
  type    = string
  default = ""
}
variable "fe_asg_instance_type" {
  type    = string
  default = ""
}
variable "fe_security_group_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

}

#-----------------------------
# ALB Variables
#-----------------------------
variable "alb_security_group_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}


variable "fe_asg_max_size" {
  type    = number
  default = 0
}
variable "fe_asg_min_size" {
  type    = number
  default = 0
}
variable "fe_asg_desired_capacity" {
  type    = number
  default = 0
}
variable "fe_asg_health_check_grace_period" {
  type    = number
  default = 0
}
variable "fe_asg_health_check_type" {
  type    = string
  default = ""
}

#------------------------------------
# CloudFront Variables
#---------------------------------------
variable "cf_origin_id" {
  type    = string
  default = ""
}

variable "cf_origin_protocol_policy" {
  type    = string
  default = ""
}

variable "cf_origin_ssl_protocols" {
  type    = list(string)
  default = [""]
}


variable "cf_allowed_methods" {
  type    = list(string)
  default = [""]

}

variable "cf_cached_methods" {
  type    = list(string)
  default = [""]
}

variable "cf_forwarded_headers" {
  type    = list(string)
  default = [""]

}


variable "cf_viewer_protocol_policy" {
  type    = string
  default = ""
}

variable "cf_min_ttl" {
  type    = number
  default = 0
}

variable "cf_default_ttl" {
  type    = number
  default = 0
}

variable "cf_max_ttl" {
  type    = number
  default = 0
}

#------------------------------
# ACM variables
#--------------------------------
variable "r53_domain_name" {
  type    = string
  default = ""
}

#------------------------------
# WAF variables
#------------------------------
variable "waf_blocked_country_codes" {
  type    = list(string)
  default = [""]
}

