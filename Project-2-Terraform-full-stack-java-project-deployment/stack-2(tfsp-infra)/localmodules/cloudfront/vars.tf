variable "envname" {
  type    = string
  default = ""
}

variable "alb_dns" {
  type    = string
  default = ""
}


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

variable "acm_cert_arn" {
  type    = string
  default = ""
}

variable "r53_domain_name" {
  type    = string
  default = ""
}

variable "route53_zoneid" {
  type    = string
  default = ""
}

variable "web_acl_id" {
  type    = string
  default = ""
}