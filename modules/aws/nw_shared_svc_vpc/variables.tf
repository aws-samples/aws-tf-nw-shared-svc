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
Network Shared Services VPC Variables
---------------------------------------------------------*/
variable "cidr_block" {
  description = <<-EOF
  CIDR block for the VPC hosting the Network Shared Services (NSS).
  The CIDR block should be in the range of /16 to /20
  EOF
  type        = string
}

variable "super_net_cidr_blocks" {
  description = <<-EOF
  CIDR blocks for Hub and Spoke super net(s).
  Must include On-Premises super net(s), if required.
  if empty, individual VPC cidr blocks will be used for routing that may hit the route table entry limits.
  EOF
  type        = list(string)
  default     = []
}

variable "az_count" {
  type        = number
  description = <<-EOF
  Number of AZs to spread the Networks Shared Services (NSS) to.
  Assumes AZs sorted a-z. Max 6 AZs.
  EOF
  default     = 3
  validation {
    condition     = var.az_count > 1 && var.az_count <= 6
    error_message = "Error: az_count Valid range is: 2 to 6."
  }
}

variable "vpc_tags" {
  description = <<-EOF
  Extra tags to add to the Networks Shared Services (NSS) VPC.
  These will be carried forward to all subnets too.
  EOF
  type        = map(string)
  default     = {}
}

variable "supported_network_segments" {
  description = <<-EOF
  List of distinct network segment names for which Transit Gateway route table(s) will be created.
  transit gateway route tables are always created for the network segments `ALL` and `ISOLATED`
  EOF
  type        = list(string)
  default     = ["ALL", "ISOLATED"]
}

/*---------------------------------------------------------
Public subnet Variables
---------------------------------------------------------*/
variable "public_cidrs" {
  description = <<-EOF
  List of CIDRs for the public subnet(s) hosting the NAT GW.
  If not provided, it will be calculated at position 1.
  EOF
  type        = list(string)
  default     = []
}

variable "nat_gateway_config" {
  description = <<-EOF
  NAT Gateways spread to be created.
  Network Shared Services (NSS) requires NAT GW. Valid values = "single_az", "all_azs"
  There is soft limit of 5 EIPs per VPC per account.
  EOF
  type        = string
  default     = "single_az"
  validation {
    error_message = "`nat_gateway_config` can only be `all_azs`, `single_az`, or `null`."
    condition     = can(regex("^(all_azs|single_az)$", var.nat_gateway_config)) || try(var.nat_gateway_config, null) == null
  }
}

variable "public_subnet_tags" {
  description = "Extra tags to add to the public subnet(s)"
  type        = map(string)
  default     = {}
}

/*---------------------------------------------------------
Transit GW Variables
---------------------------------------------------------*/
#TODO allow using existing TGW, accept tgw_id as input

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session."
  type        = string
  default     = "64512"
}

variable "tgw_tags" {
  description = "Extra tags to add to the transit gateway."
  type        = map(string)
  default     = {}
}

variable "tgw_cidrs" {
  description = <<-EOF
  List of CIDRs for the subnet(s) hosting the TGW endpoints.
  If not provided, it will be calculated at position 2.
  The recommended CIDR block range is /28.
  EOF
  type        = list(string)
  default     = []
}

variable "tgw_subnet_tags" {
  description = "Extra tags to add to the transit gw subnet(s)"
  type        = map(string)
  default     = {}
}

/*---------------------------------------------------------
VPC Endpoint Subnet Variables
---------------------------------------------------------*/
variable "enable_vpce" {
  description = <<-EOF
  If enabled, subnet(s) for VPC endpoints will be created.
  EOF
  type        = bool
  default     = false
}

variable "vpce_cidrs" {
  description = <<-EOF
  List of CIDRs for the subnet(s) hosting the VPC endpoint(s) for the supported AWS Services.
  If not provided, it will be calculated at position 3.
  The recommended CIDR block range is /24.
  EOF
  type        = list(string)
  default     = []
}

variable "vpce_subnet_tags" {
  description = "Extra tags to add to the vpc endpoint subnet(s)"
  type        = map(string)
  default     = {}
}

/*---------------------------------------------------------
DNS Endpoint Subnet Variables
---------------------------------------------------------*/
variable "enable_dnse" {
  description = <<-EOF
  If enabled, subnet(s) for DNS resolver endpoints will be created.
  EOF
  type        = bool
  default     = false
}

variable "dnse_cidrs" {
  description = <<-EOF
  List of CIDRs for the subnet(s) hosting the DNS resolver endpoint(s).
  If not provided, it will be calculated at position 4.
  The recommended CIDR block range is /28.
  EOF
  type        = list(string)
  default     = []
}

variable "dnse_subnet_tags" {
  description = "Extra tags to add to the dns resolver endpoint subnet(s)"
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
