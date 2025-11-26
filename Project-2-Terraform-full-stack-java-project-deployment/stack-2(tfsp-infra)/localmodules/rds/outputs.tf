output "rds_db_end_point" {
  value = aws_db_instance.tfsp_rds_instance.endpoint
}

output "rds_db_username" {
  value = aws_db_instance.tfsp_rds_instance.username
}

output "rds_db_password" {
  value = aws_db_instance.tfsp_rds_instance.password
}