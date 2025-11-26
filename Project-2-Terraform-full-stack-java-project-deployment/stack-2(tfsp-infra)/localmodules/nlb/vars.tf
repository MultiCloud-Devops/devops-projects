variable "envname" {
  type    = string
  default = ""

}

variable "vpc_id" {
  type    = string
  default = ""

}

variable "nlb_security_group_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = []

}