variable "envname" {
  type    = string
  default = ""
}

variable "waf_blocked_country_codes" {
  type    = list(string)
  default = [""]
}


