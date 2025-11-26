locals {
  be_user_data = templatefile("${path.module}/includes/user_data_be.tpl", {
    envname           = var.envname
    be_infra_bkt      = data.terraform_remote_state.infra_state_files.outputs.remote_be_infra_bkt
    be_infra_jar_file = var.be_infra_jar_file
    rds_db_end_point  = var.rds_db_end_point
    rds_db_username   = var.rds_db_username
    rds_db_password   = var.rds_db_password
    hook_name         = "instance-launch-hook"
  })

  fe_user_data = templatefile("${path.module}/includes/user_data_fe.tpl", {
    envname          = var.envname
    fe_infra_bkt     = data.terraform_remote_state.infra_state_files.outputs.remote_fe_infra_bkt
    nlb_dns_endpoint = var.nlb_dns_endpoint
  })

}