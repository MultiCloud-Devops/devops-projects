variable "envname" {
  type    = string
  default = ""
}

variable "rds_db_end_point" {
  type    = string
  default = ""
}

variable "be_infra_jar_file" {
  type    = string
  default = ""
}

variable "tfsp_infra_be_bucket" {
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

variable "vpc_id" {
  type    = string
  default = ""
}

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
variable "be_asg_target_group_arn" {
  type    = string
  default = ""
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

variable "subnet_id" {
  type    = string
  default = ""

}

variable "rds_db_username" {
  type    = string
  default = ""
}

variable "rds_db_password" {
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



# Variables for FE Instances
variable "fe_security_group_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

}

variable "fe_asg_ami_id" {
  type    = string
  default = ""
}

variable "fe_asg_instance_type" {
  type    = string
  default = ""
}

variable "nlb_dns_endpoint" {
  type    = string
  default = ""
}

variable "fe_asg_target_group_arn" {
  type    = string
  default = ""
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