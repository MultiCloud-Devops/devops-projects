resource "aws_s3_bucket" "tfsp_infra_be_bucket" {
  bucket = var.tfsp_infra_be_bucket

  tags = {
    Name = var.tfsp_infra_be_bucket
  }

}

resource "aws_s3_bucket" "tfsp_infra_fe_bucket" {
  bucket = var.tfsp_infra_fe_bucket

  tags = {
    Name = var.tfsp_infra_fe_bucket
  }

}