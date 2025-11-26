#---------------------------------
# Data Sources Parameter Store
#---------------------------------
data "aws_ssm_parameter" "tfsp_db_password" {
  name            = "/tfsp/${var.envname}/db/${var.db_password_parameter_name}"
  with_decryption = true
}

data "aws_ssm_parameter" "tfsp_db_username" {
  name            = "/tfsp/${var.envname}/db/${var.db_username_parameter_name}"
  with_decryption = true
}

data "aws_kms_key" "aws_managed_rds_key" {
  key_id = "alias/aws/rds"
}