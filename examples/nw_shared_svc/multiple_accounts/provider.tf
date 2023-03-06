terraform {
  required_version = ">= v1.3.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.56.0"
    }
  }

  # Configure the S3 backend
  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "aws-tf-nw-shared-svc-dev-terraform-state-bucket"
    dynamodb_table = "aws-tf-nw-shared-svc-dev-terraform-state-locktable"
    key            = "aws-tf-nw-shared-svc/examples/nw_shared_svc/multiple_accounts/terraform.tfstate"
  }
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "aws-tf-nw-shared-svc-dev-terraform-state-bucket"
    dynamodb_table = "aws-tf-nw-shared-svc-dev-terraform-state-locktable"
    key            = "bootstrap/terraform.tfstate"
  }
}

# Configure the AWS Provider to assume_role and set default region
provider "aws" {
  region = var.region

  assume_role {
    role_arn = data.terraform_remote_state.bootstrap.outputs.network_account_role_arn
  }
}
