/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
variable "region" {
  description = "The AWS Region e.g. us-east-1 for the environment"
  type        = string
}

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
variable "tags" {
  description = "Common and mandatory tags for the resources"
  type        = map(string)
  default     = {}
}

/*---------------------------------------------------------
Bootstrap Variables
---------------------------------------------------------*/
variable "s3_statebucket_name" {
  description = "Name of the S3 bucket used for storing Terraform state files. If not provided, bucket will not be created."
  type        = string
  default     = null
}

variable "dynamo_locktable_name" {
  description = "Name of the DynamoDB table used for Terraform state locking. If not provided, table will not be created."
  type        = string
  default     = null
}

variable "delegated_access_only" {
  description = "When `delegated_access_only` is true, only delegated access role is created."
  type        = bool
  default     = false
}

variable "delegated_role_name" {
  description = "Provide (optional) name for the delegated Terraform role. Otherwise `Terraformer` will be assumed."
  type        = string
  default     = "Terraformer"
}

variable "delegated_access_policy" {
  description = <<-EOF
  Provide (optional) policy for the delegated Terraform role. Otherwise "AdministratorAccess" will be assumed.
  EOF
  type        = string
  default     = null
}
