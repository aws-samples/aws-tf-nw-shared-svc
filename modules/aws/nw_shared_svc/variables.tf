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
Encryption
---------------------------------------------------------*/
variable "kms_admin_roles" {
  description = <<-EOF
  List Administrator roles for KMS.
  Provide at least one Admin role if kms needs to be created for the encryption of NSS VPC flow logs e.g. ["Admin"].
  It can be empty if flow logs are not enabled for any of the Network Shared Services e.g. VPCE
  It can be empty if flow logs are enabled but `flow_log_specs.encrypted` is false.
  EOF
  type        = list(string)
  default     = []
}

/*---------------------------------------------------------
Network Shared Services Variables
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
    condition     = var.az_count > 1 && var.az_count <= 8
    error_message = "Error: az_count Valid range is: 2 to 8."
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

variable "flow_log_specs" {
  description = <<-EOF
  Options to customize the VPC flow logs, effective if flow logs are enabled for any of the Network Shared Services e.g. VPCE.
  - `destination_type`, optional. Valid values: cloud-watch-logs or s3. default: cloud-watch-logs
  - `destination_name`, optional. Provide an existing `destination_name`.
    For `destination_type` s3, provide an existing s3 bucket name
    For `destination_type` cloud-watch-logs, provide an existing cloudwatch log group
    If not provided, a destination will be created based on the `destination_type`
  - `encrypted`, optional. Should the flow logs be encrypted. default: `true`
    Not applicable, if `destination_name` is provided.
  - `kms_alias`, optional. Provide an existing `kms_alias` to encrypt the flow logs.
    If not provided, an appropriate KMS is created based on the `destination_type`
    Not applicable, if `encrypted` is false or `destination_name` is provided.
  - `flow_log_role`, optional. Provide an existing IAM role for the flow log with permissions to log to `destination_type`
    If not provided, an appropriate IAM role is created with permissions to log to `destination_type`
  `traffic_type`, optional. Type for traffic to capture in the flow log. ACCEPT, REJECT, or ALL. Default is ALL
  `max_aggregation_interval`, optional. Max aggregation interval for the flow log capture before sending to destination. 600 or 60. Default is 600
  `file_format`, optional. if `destination_type` is s3, provide one of the supported file formats. plain-text or parquet. Default is plain-text
  `per_hour_partition`, optional. if `destination_type` is s3, should one hour partition be created. Default is false
  `hive_compatible_partitions`, optional. if `destination_type` is s3, should hive compatible partition be created. Default is false
  EOF
  type = object({
    destination_type           = optional(string, "cloud-watch-logs")
    destination_name           = optional(string, "")
    encrypted                  = optional(bool, true)
    kms_alias                  = optional(string, "")
    flow_log_role              = optional(string, "")
    traffic_type               = optional(string, "ALL")
    max_aggregation_interval   = optional(number, 600)
    file_format                = optional(string, "plain-text")
    per_hour_partition         = optional(bool, false)
    hive_compatible_partitions = optional(bool, false)
  })
  validation {
    condition     = try(length(var.flow_log_specs.destination_type), 0) == 0 ? true : contains(["cloud-watch-logs", "s3"], var.flow_log_specs.destination_type)
    error_message = "Error: destination_type Valid values: cloud-watch-logs or s3."
  }
  validation {
    condition     = try(length(var.flow_log_specs.traffic_type), 0) == 0 ? true : contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_specs.traffic_type)
    error_message = "Error: traffic_type Valid values: ACCEPT,REJECT, or ALL."
  }
  validation {
    condition     = try(length(var.flow_log_specs.file_format), 0) == 0 ? true : contains(["plain-text", "parquet"], var.flow_log_specs.file_format)
    error_message = "Error: file_format Valid values: plain-text or parquet."
  }
  validation {
    condition     = try(abs(var.flow_log_specs.max_aggregation_interval), 0) == 0 ? true : contains([600, 60], var.flow_log_specs.max_aggregation_interval)
    error_message = "Error: max_aggregation_interval Valid values: 60 or 600."
  }
  default = {
    destination_type           = "cloud-watch-logs"
    destination_name           = ""
    encrypted                  = true
    kms_alias                  = ""
    flow_log_role              = ""
    traffic_type               = "ALL"
    max_aggregation_interval   = 600
    file_format                = "plain-text"
    per_hour_partition         = false
    hive_compatible_partitions = false
  }
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
  Provide list of AWS Account Ids that are not part of any AWS Organizations OUs in the `share_with_ous`
  The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).
  e.g. `aws ram enable-sharing-with-aws-organization`
  EOF
  type        = list(string)
  default     = []
}


/*---------------------------------------------------------
VPC Endpoint Variables
---------------------------------------------------------*/
variable "enable_vpce_flow_log" {
  description = <<-EOF
  Enable VPC flow log for all the VPC endpoints, unless overridden by `vpce_flow_log_service_codes`.
  if true and `vpce_flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.
  if false VPC flow logs will be disabled.
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

variable "vpce_service_codes" {
  description = <<-EOF
  List of the service codes for the supported AWS Services for which VPC endpoints will be created.
  If empty or null, no VPC endpoints will be created.
  EOF
  type        = list(string)
  default     = []
}

variable "vpce_flow_log_service_codes" {
  description = <<-EOF
  List of the service codes for the supported AWS Services for which flow log will be enabled.
  if `enable_vpce_flow_log` is true and `vpce_flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.
  if `enable_vpce_flow_log` is true and `vpce_flow_log_service_codes` is not empty, flow logs will be enabled at the ENI level for the listed services.
  if `enable_vpce_flow_log` is false VPC flow logs will be disabled, regardless of `vpce_flow_log_service_codes`
  EOF
  type        = list(string)
  default     = []
}

variable "generate_vpce_test_script" {
  description = <<-EOF
  Generate a test script that can be used to test all the provisioned VPC endpoints.
  EOF
  type        = bool
  default     = false
}

/*---------------------------------------------------------
DNS Endpoint Variables
---------------------------------------------------------*/
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
  description = "Extra tags to add to the dns endpoint subnet(s)"
  type        = map(string)
  default     = {}
}

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

# # TODO for future
# variable "enable_dns_query_log" {
#   description = <<-EOF
#   Enable DNS Query log for DNS resolvers.
#   EOF
#   type        = bool
#   default     = false
# }

# # TODO for future
# variable "enable_dns_qps_alarm" {
#   description = <<-EOF
#   Enable CloudWatch alarm for DNS QPS.
#   EOF
#   type        = bool
#   default     = false
# }
