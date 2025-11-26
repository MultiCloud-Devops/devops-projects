locals {
  tfsp_db_password     = sensitive(data.aws_ssm_parameter.tfsp_db_password.value)
  tfsp_db_username     = sensitive(data.aws_ssm_parameter.tfsp_db_username.value)
  tfsp_rds_kms_key_arn = data.aws_kms_key.aws_managed_rds_key.arn
}