output "remote_be_infra_bkt" {
  value = aws_s3_bucket.tfsp_infra_be_bucket.bucket
}

output "remote_fe_infra_bkt" {
  value = aws_s3_bucket.tfsp_infra_fe_bucket.bucket
}