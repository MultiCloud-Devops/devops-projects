provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::556885871565:role/terraform_trust_role"
    session_name = "tfspAppSession"
  }

}

terraform {
  # required_version = "1.13.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
  backend "s3" {
    bucket         = "tfsp-app-state-file"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tfsp-app-state-table"

  }
}