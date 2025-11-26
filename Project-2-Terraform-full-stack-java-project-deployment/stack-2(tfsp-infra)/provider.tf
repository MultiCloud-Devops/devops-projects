provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::556885871565:role/terraform_trust_role"
    session_name = "tfspInfraSession"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
  backend "s3" {
    bucket         = "tfsp-infra-state-file"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tfsp-infra-state-table"

  }
}