/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
variable "project" {
  description = "Project name, used as prefix/suffix for resource identification."
  type        = string
}

variable "env_name" {
  description = "Environment name e.g. dev, prod, used for resource identification."
  type        = string
}

variable "tags" {
  description = "Common and mandatory tags for the resources."
  type        = map(string)
}

/*---------------------------------------------------------
Transit GW Variables
---------------------------------------------------------*/
variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session."
  type        = string
  default     = "64512"
}

variable "tgw_tags" {
  description = "Extra tags to add to the transit gateway resource."
  type        = map(string)
  default     = {}
}

variable "share_with_org" {
  description = <<-EOF
  Share the services at the Organization level.
  If `share_with_org` is true then `share_with_ous` is ignored.
  If `share_with_org` is true then `share_with_accounts` is ignored.
  The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).
  e.g. `aws ram enable-sharing-with-aws-organization`
  EOF
  type        = bool
  default     = true
}

variable "share_with_ous" {
  description = <<-EOF
  Share the services with list of AWS Organizations OU, like ou-xyz-abcdefg
  If `share_with_org` is true then `share_with_ous` is ignored.
  The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).
  e.g. `aws ram enable-sharing-with-aws-organization`
  EOF
  type        = list(string)
  default     = []
}

variable "share_with_accounts" {
  description = <<-EOF
  Share the services with list of AWS Accounts. like 111111111111
  If `share_with_org` is true then `share_with_accounts` is ignored.
  Provided list of AWS Account Ids that are not part of any AWS Organizations OUs in the `share_with_ous`
  The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).
  e.g. `aws ram enable-sharing-with-aws-organization`
  EOF
  type        = list(string)
  default     = []
}
