variable "envname" {
  type    = string
  default = ""
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = [""]
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

variable "vpc_id" {
  type    = string
  default = ""
}

variable "db_password_parameter_name" {
  type    = string
  default = ""
}

variable "db_username_parameter_name" {
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

variable "rds_db_allocated_storage" {
  type    = number
  default = 0
}