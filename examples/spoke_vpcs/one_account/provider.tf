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
    key            = "aws-tf-nw-shared-svc/examples/spoke_vpcs/one_account/terraform.tfstate"
  }
}

data "terraform_remote_state" "nw_shared_svc" {
  backend = "s3"
  config = {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "aws-tf-nw-shared-svc-dev-terraform-state-bucket"
    dynamodb_table = "aws-tf-nw-shared-svc-dev-terraform-state-locktable"
    key            = "aws-tf-nw-shared-svc/examples/nw_shared_svc/one_account/terraform.tfstate"
  }
}

# Configure the AWS Provider to use the tooling account
provider "aws" {
  region = var.region
}
