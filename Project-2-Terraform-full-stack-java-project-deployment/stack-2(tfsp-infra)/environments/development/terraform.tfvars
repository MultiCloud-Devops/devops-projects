#--------------------------------------
# Common Project Variables
#--------------------------------------
env_name = "dev"


#--------------------------------------
# VPC Module Variables
#--------------------------------------
vpc_cidr_block = "10.0.0.0/16"



#--------------------------------------
# RDS Module Variables
#--------------------------------------
rds_security_group_ingress = [
  {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]
db_password_parameter_name = "rds-password"
rds_db_engine              = "mysql"
rds_db_engine_version      = "8.0.42"
rds_db_instance_class      = "db.t4g.micro"
db_username_parameter_name = "rds-username"
rds_db_allocated_storage   = 20

#--------------------------------------
# NLB Module Variables
#--------------------------------------
nlb_security_group_ingress = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]

#--------------------------------------
# ASG Module Variables
#--------------------------------------
be_infra_jar_file                       = "datastore-0.0.7.jar"
be_terraform_remote_state_bucket        = "tfsp-app-state-file"
be_terraform_remote_state_bucket_region = "us-east-1"
be_security_group_ingress = [
  {
    from_port   = 8084
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]

be_asg_ami_id                    = "ami-07860a2d7eb515d9a"
be_asg_instance_type             = "t3.micro"
be_asg_desired_capacity          = 1
be_asg_max_size                  = 1
be_asg_min_size                  = 1
be_asg_health_check_grace_period = 300
be_asg_health_check_type         = "EC2"

be_asg_scale_down_cron_expression  = "0 10 * * 1-5"
be_asg_scale_down_time_zone        = "UTC"
be_asg_scale_down_min_size         = 0
be_asg_scale_down_max_size         = 0
be_asg_scale_down_desired_capacity = 0

be_asg_scale_up_cron_expression  = "35 9 * * 1-5"
be_asg_scale_up_time_zone        = "UTC"
be_asg_scale_up_min_size         = 2
be_asg_scale_up_max_size         = 2
be_asg_scale_up_desired_capacity = 2



#--------------------------------------
# CloudWatch Variables  
#--------------------------------------
be_cloudwatch_log_group_name = "/datastore/app"

#--------------------------------------
# Lambda Variables
#--------------------------------------
slack_web_hook_url               = ""
be_cloudwatch_lambda_runtime     = "python3.12"
be_cloudwatch_lambda_memory_size = 128
be_cloudwatch_lambda_timeout     = 3


#--------------------------------------
# FE ASG Variables
#--------------------------------------
fe_asg_ami_id        = "ami-07860a2d7eb515d9a"
fe_asg_instance_type = "t3.micro"
fe_security_group_ingress = [
  {
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]

#--------------------------------------
# ALB Module Variables
#--------------------------------------
alb_security_group_ingress = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
fe_asg_max_size                  = 1
fe_asg_min_size                  = 1
fe_asg_desired_capacity          = 1
fe_asg_health_check_grace_period = 300
fe_asg_health_check_type         = "EC2"


#-----------------------------------
# CloudFront variables
#-----------------------------------
cf_origin_id              = "tfsp-cf-alb-origin"
cf_origin_protocol_policy = "http-only"
cf_origin_ssl_protocols   = ["TLSv1.2"]

cf_allowed_methods   = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
cf_cached_methods    = ["GET", "HEAD"]
cf_forwarded_headers = ["Host", "Origin", "Sec-WebSocket-Key", "Sec-WebSocket-Version", "Sec-WebSocket-Extensions"]

cf_viewer_protocol_policy = "allow-all"
cf_min_ttl                = 0
cf_default_ttl            = 3600
cf_max_ttl                = 86400

#----------------------------------
# ACM variables
#----------------------------------
r53_domain_name = "krishnal.shop"

#---------------------------------
# WAF variables
#-----------------------------------
waf_blocked_country_codes = ["CN", "RU", "IN"]