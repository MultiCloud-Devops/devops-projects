#------------------------------
# Terraform Remote State Data Source
#------------------------------
data "terraform_remote_state" "infra_state_files" {
  backend = "s3"

  config = {
    bucket = var.be_terraform_remote_state_bucket
    key    = "env/${var.envname}/terraform.tfstate"
    region = var.be_terraform_remote_state_bucket_region
  }
}