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
VPC/Subnet(s) for DNS Resolver Endpoint(s)
---------------------------------------------------------*/
variable "vpc_tags" {
  description = <<-EOF
  Tags to discover target VPC, these tags should uniquely identify a VPC to host the DNS resolver Endpoint(s).
  Other option is to provide the mutually exclusive `vpc_id`.
  Either `vpc_tags` or `vpc_id` must be provided.
  If both are provided `vpc_id` is used.
  EOF
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = <<-EOF
  Identifies the target VPC to host the DNS resolver Endpoint(s).
  Other option is to provide the mutually exclusive `vpc_tags` to discover the VPC.
  Either `vpc_tags` or `vpc_id` must be provided.
  If both are provided `vpc_id` is used.
  EOF
  type        = string
  default     = null
}

variable "subnet_tags" {
  description = <<-EOF
  Tags to discover target subnets in the VPC, these tags should identify one or more subnets to host the DNS resolver Endpoint(s).
  Other option is to provide the mutually exclusive `subnet_ids` for the target subnets.
  Either `subnet_tags` or `subnet_ids` must be provided.
  If both are provided `subnet_ids` is used.
  EOF
  type        = map(string)
  default     = {}
}

# variable "subnet_ids" {
#   description = <<-EOF
#   List of target subnet id(s) to host the DNS resolver Endpoint(s).
#   Other options is to provide the mutually exclusive `subnet_tags` to discover target subnet(s) in the VPC.
#   Either `subnet_tags` or `subnet_ids` must be provided.
#   If both are provided `subnet_ids` is used.
#   EOF
#   type        = list(string)
#   default     = []
# }

variable "subnets" {
  description = <<-EOF
  List of target subnet(s) to host the DNS resolver Endpoint(s).
  Other options is to provide the mutually exclusive `subnet_tags` to discover target subnet(s) in the VPC.
  Either `subnet_tags` or `subnets` must be provided.
  If both are provided `subnets` is used.
  EOF
  type = list(object({
    subnet_id  = string
    cidr_block = string
  }))
  default = []
}

/*---------------------------------------------------------
DNS Endpoint Variables
---------------------------------------------------------*/
variable "dnse_tags" {
  description = "Extra tags to add to the DNS resolver endpoints."
  type        = map(string)
  default     = {}
}

variable "on_premises_cidrs" {
  description = <<-EOF
  List of on-premises CIDR blocks that will use inbound DNS resolver endpoint.
  Check for the output `inbound_dns_resolver_endpoints`, for configuring on-premises DNS server(s).
  EOF
  type        = list(string)
  default     = []
}

variable "outbound_dns_resolver_config" {
  description = <<-EOF
  List of outbound DNS resolver configurations.
  If specified, outbound resolver endpoint(s) along with forward rules will be created.
  `domain_name`, mandatory. On-premises domain name, for which DNS query will be forwarded to the `target_ip_addresses`
  `target_ip_addresses`. mandatory. On-premises DNS server IP address.
  EOF
  type = list(object({
    domain_name         = string
    target_ip_addresses = list(string)
  }))
  default = []
}

# # TODO support dns query log
# variable "enable_dns_query_log" {
#   description = <<-EOF
#   Enable DNS Query log for DNS resolvers.
#   EOF
#   type        = bool
#   default     = false
# }

# # TODO support dns qps alarm
# variable "enable_dns_qps_alarm" {
#   description = <<-EOF
#   Enable CloudWatch alarm for DNS QPS.
#   EOF
#   type        = bool
#   default     = false
# }

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
