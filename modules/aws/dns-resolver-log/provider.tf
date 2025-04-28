terraform {
  required_version = ">= v1.10.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
  }
}
