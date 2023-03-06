/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
region = "us-east-1"

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
tags = {
  Env     = "DEV"
  Project = "aws-tf-nw-shared-svc"
}

/*---------------------------------------------------------
Bootstrap Variables
---------------------------------------------------------*/
s3_statebucket_name   = "aws-tf-nw-shared-svc-dev-terraform-state-bucket"
dynamo_locktable_name = "aws-tf-nw-shared-svc-dev-terraform-state-locktable"
