output "tf_be_user_data" {
  value     = module.tfsp_asg.tf_be_user_data
  sensitive = true
}

output "tf_fe_user_data" {
  value     = module.tfsp_asg.tf_fe_user_data
  sensitive = true
}