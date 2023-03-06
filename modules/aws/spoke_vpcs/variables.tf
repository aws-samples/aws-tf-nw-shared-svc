/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
variable "project" {
  description = "Project name, used as prefix/suffix for resource identification."
  type        = string
}

variable "tags" {
  description = "Common and mandatory tags for the resources."
  type        = map(string)
}

/*---------------------------------------------------------
Spoke VPC Variables
---------------------------------------------------------*/
variable "nw_shared_svc_attributes" {
  description = <<-EOF
  Network Shared Service attributes
  Outputs from the Network Shared Service module.
  Work with your Network Shared Services (NSS) to identify this.
  EOF
  type        = any
}

variable "spoke_vpc_specs" {
  description = <<-EOF
  List of specs for the Spoke VPC(s).
  - `name_prefix`, mandatory. A short name that will be used to name the VPC.
  - `env_name`, mandatory. Environment name e.g. dev, prod, used for resource identification.
  - `cidr_block`, mandatory. CIDR block for the VPC hosting the Network Shared Services (NSS).
    The CIDR block should be in the range of /16 to /20.
  - `az_count`, mandatory. Number of AZs for which subnet(s) are created.
    Assumes AZs sorted a-z. Max 6 AZs.
  - `tags`, optional. Extra tags to add to the VPC. These will be carried forward to all subnets too.
    Default: {}.
  - `network_segment`, optional. network segment name to which spoke vpc will be connected.
    Defaults to "ISOLATED", if the provided network segment is not supported by NSS.
    Default: "ISOLATED"
  - `enable_centralized_vpc_endpoints`, optional. Should the NSS `Centralized VPC Endpoints` be enabled for the Spoke VPC?
    Default: false
  - `vpce_service_codes`, optional. List of supported service codes for which the `Centralized VPC Endpoints` is enabled for the Spoke VPC.
    If empty, all the enabled VPC Endpoints by the NSS are enabled for the Spoke VPC.
    If contains any service code that is not yet enabled by NSS, it will not be enabled for the Spoke VPC.
  - `enable_hybrid_dns`, optional. Should the NSS `Hybrid DNS` be enabled for the Spoke VPC?
    Default: false
  - `enable_centralized_egress_to_internet`, optional. Should the NSS `Centralized Egress to Internet` be enabled for the Spoke VPC?
    Default: false
    Note: **not yet implemented, must use false**
  - `enable_centralized_ingress_from_internet`, optional. Should the NSS `Centralized Ingress from Internet` be enabled for the Spoke VPC?
    Default: false
    Note: **not yet implemented, must use false**
  - `create_test_ec2`, optional. Should a test EC2 instance be created in all the subnets of the Spoke VPC?
    Default: false
  - `subnets`, mandatory.  = List of specs for the Subnet(s) in the Spoke VPC.
    - `name_prefix`, mandatory. A short name that will be used to name the subnet.
    - `cidrs`, mandatory. List of CIDRs for the subnet(s).
      Length of the list must be greater of equal to the `az_count` for the Spoke VPC.
    - `type`, mandatory. Type of the subnet.
      Must be "public", "private" or "transit_gateway"
      For the Spoke VPC to be of any practical use, it must have at least one "transit_gateway" (/28) subnet and one "private" subnet.
      Default: "private"
    - `tags`, optional. Extra tags to add to the subnet.
      Default: {}.
  EOF
  type = list(object({
    name_prefix                              = string
    env_name                                 = string
    cidr_block                               = string
    az_count                                 = number
    tags                                     = optional(map(string), {})
    network_segment                          = optional(string, "")
    enable_centralized_vpc_endpoints         = optional(bool, true)
    vpce_service_codes                       = optional(list(string), [])
    enable_hybrid_dns                        = optional(bool, true)
    enable_centralized_egress_to_internet    = optional(bool, false)
    enable_centralized_ingress_from_internet = optional(bool, false)
    create_test_ec2                          = optional(bool, false)
    subnets = list(object({
      name_prefix = string
      cidrs       = list(string)
      type        = string
      tags        = optional(map(string), {})
    }))
  }))
  default = []
  #TODO validate max 6 az
  #TODO validate subnet type
}

variable "ec2_test_script" {
  description = <<-EOF
  Name of the test script that can be used to test all ec2 instances created for testing.
  if not provided, the test script will not be created.
  EOF
  type        = string
  default     = null
}
