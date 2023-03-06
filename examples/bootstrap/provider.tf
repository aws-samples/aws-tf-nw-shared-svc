terraform {
  required_version = ">= v1.3.9"
  # Set minimum required versions for providers using lazy matching
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
    key            = "bootstrap/terraform.tfstate"
  }
}

# Configure the AWS Provider to assume_role and set default region
#tooling account
provider "aws" {
  region  = var.region
  profile = "tooling-admin"
  alias   = "tooling"
}

#network account
provider "aws" {
  region  = var.region
  profile = "nw-admin"
  alias   = "network"
}

#dev account
provider "aws" {
  region  = var.region
  profile = "dev-admin"
  alias   = "dev"
}

#test account
provider "aws" {
  region  = var.region
  profile = "test-admin"
  alias   = "test"
}

#sec account
provider "aws" {
  region  = var.region
  profile = "sec-admin"
  alias   = "sec"
}
