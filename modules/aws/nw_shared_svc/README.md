<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.56.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.63.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hybrid_dns"></a> [hybrid\_dns](#module\_hybrid\_dns) | ../hybrid_dns | n/a |
| <a name="module_shared_services_vpc"></a> [shared\_services\_vpc](#module\_shared\_services\_vpc) | ../nw_shared_svc_vpc | n/a |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | ../vpc_endpoints | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_managed_prefix_list_entry.nss_pl_on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list_entry) | resource |
| [aws_ec2_managed_prefix_list_entry.nw_segment_pl_on_prem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the VPC hosting the Network Shared Services (NSS).<br>The CIDR block should be in the range of /16 to /20 | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod, used for resource identification. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name, used as prefix/suffix for resource identification. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources. | `map(string)` | n/a | yes |
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | Private Autonomous System Number (ASN) for the Amazon side of a BGP session. | `string` | `"64512"` | no |
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Number of AZs to spread the Networks Shared Services (NSS) to.<br>Assumes AZs sorted a-z. Max 6 AZs. | `number` | `3` | no |
| <a name="input_dnse_cidrs"></a> [dnse\_cidrs](#input\_dnse\_cidrs) | List of CIDRs for the subnet(s) hosting the DNS resolver endpoint(s).<br>If not provided, it will be calculated at position 4.<br>The recommended CIDR block range is /28. | `list(string)` | `[]` | no |
| <a name="input_dnse_subnet_tags"></a> [dnse\_subnet\_tags](#input\_dnse\_subnet\_tags) | Extra tags to add to the dns endpoint subnet(s) | `map(string)` | `{}` | no |
| <a name="input_dnse_tags"></a> [dnse\_tags](#input\_dnse\_tags) | Extra tags to add to the DNS resolver endpoints. | `map(string)` | `{}` | no |
| <a name="input_enable_vpce_flow_log"></a> [enable\_vpce\_flow\_log](#input\_enable\_vpce\_flow\_log) | Enable VPC flow log for all the VPC endpoints, unless overridden by `vpce_flow_log_service_codes`.<br>if true and `vpce_flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.<br>if false VPC flow logs will be disabled. | `bool` | `false` | no |
| <a name="input_flow_log_specs"></a> [flow\_log\_specs](#input\_flow\_log\_specs) | Options to customize the VPC flow logs, effective if flow logs are enabled for any of the Network Shared Services e.g. VPCE.<br>- `destination_type`, optional. Valid values: cloud-watch-logs or s3. default: cloud-watch-logs<br>- `destination_name`, optional. Provide an existing `destination_name`.<br>  For `destination_type` s3, provide an existing s3 bucket name<br>  For `destination_type` cloud-watch-logs, provide an existing cloudwatch log group<br>  If not provided, a destination will be created based on the `destination_type`<br>- `encrypted`, optional. Should the flow logs be encrypted. default: `true`<br>  Not applicable, if `destination_name` is provided.<br>- `kms_alias`, optional. Provide an existing `kms_alias` to encrypt the flow logs.<br>  If not provided, an appropriate KMS is created based on the `destination_type`<br>  Not applicable, if `encrypted` is false or `destination_name` is provided.<br>- `flow_log_role`, optional. Provide an existing IAM role for the flow log with permissions to log to `destination_type`<br>  If not provided, an appropriate IAM role is created with permissions to log to `destination_type`<br>`traffic_type`, optional. Type for traffic to capture in the flow log. ACCEPT, REJECT, or ALL. Default is ALL<br>`max_aggregation_interval`, optional. Max aggregation interval for the flow log capture before sending to destination. 600 or 60. Default is 600<br>`file_format`, optional. if `destination_type` is s3, provide one of the supported file formats. plain-text or parquet. Default is plain-text<br>`per_hour_partition`, optional. if `destination_type` is s3, should one hour partition be created. Default is false<br>`hive_compatible_partitions`, optional. if `destination_type` is s3, should hive compatible partition be created. Default is false | <pre>object({<br>    destination_type           = optional(string, "cloud-watch-logs")<br>    destination_name           = optional(string, "")<br>    encrypted                  = optional(bool, true)<br>    kms_alias                  = optional(string, "")<br>    flow_log_role              = optional(string, "")<br>    traffic_type               = optional(string, "ALL")<br>    max_aggregation_interval   = optional(number, 600)<br>    file_format                = optional(string, "plain-text")<br>    per_hour_partition         = optional(bool, false)<br>    hive_compatible_partitions = optional(bool, false)<br>  })</pre> | <pre>{<br>  "destination_name": "",<br>  "destination_type": "cloud-watch-logs",<br>  "encrypted": true,<br>  "file_format": "plain-text",<br>  "flow_log_role": "",<br>  "hive_compatible_partitions": false,<br>  "kms_alias": "",<br>  "max_aggregation_interval": 600,<br>  "per_hour_partition": false,<br>  "traffic_type": "ALL"<br>}</pre> | no |
| <a name="input_generate_vpce_test_script"></a> [generate\_vpce\_test\_script](#input\_generate\_vpce\_test\_script) | Generate a test script that can be used to test all the provisioned VPC endpoints. | `bool` | `false` | no |
| <a name="input_kms_admin_roles"></a> [kms\_admin\_roles](#input\_kms\_admin\_roles) | List Administrator roles for KMS.<br>Provide at least one Admin role if kms needs to be created for the encryption of NSS VPC flow logs e.g. ["Admin"].<br>It can be empty if flow logs are not enabled for any of the Network Shared Services e.g. VPCE<br>It can be empty if flow logs are enabled but `flow_log_specs.encrypted` is false. | `list(string)` | `[]` | no |
| <a name="input_nat_gateway_config"></a> [nat\_gateway\_config](#input\_nat\_gateway\_config) | NAT Gateways spread to be created.<br>Network Shared Services (NSS) requires NAT GW. Valid values = "single\_az", "all\_azs"<br>There is soft limit of 5 EIPs per VPC per account. | `string` | `"single_az"` | no |
| <a name="input_on_premises_cidrs"></a> [on\_premises\_cidrs](#input\_on\_premises\_cidrs) | List of on-premises CIDR blocks that will use inbound DNS resolver endpoint.<br>Check for the output `inbound_dns_resolver_endpoints`, for configuring on-premises DNS server(s). | `list(string)` | `[]` | no |
| <a name="input_outbound_dns_resolver_config"></a> [outbound\_dns\_resolver\_config](#input\_outbound\_dns\_resolver\_config) | List of outbound DNS resolver configurations.<br>If specified, outbound resolver endpoint(s) along with forward rules will be created.<br>`domain_name`, mandatory. On-premises domain name, for which DNS query will be forwarded to the `target_ip_addresses`<br>`target_ip_addresses`. mandatory. On-premises DNS server IP address. | <pre>list(object({<br>    domain_name         = string<br>    target_ip_addresses = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_public_cidrs"></a> [public\_cidrs](#input\_public\_cidrs) | List of CIDRs for the public subnet(s) hosting the NAT GW.<br>If not provided, it will be calculated at position 1. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Extra tags to add to the public subnet(s) | `map(string)` | `{}` | no |
| <a name="input_share_with_accounts"></a> [share\_with\_accounts](#input\_share\_with\_accounts) | Share the services with list of AWS Accounts. like 111111111111<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>Provide list of AWS Account Ids that are not part of any AWS Organizations OUs in the `share_with_ous`<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_share_with_org"></a> [share\_with\_org](#input\_share\_with\_org) | Share the services at the Organization level.<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `bool` | `true` | no |
| <a name="input_share_with_ous"></a> [share\_with\_ous](#input\_share\_with\_ous) | Share the services with list of AWS Organizations OU, like ou-xyz-abcdefg<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_super_net_cidr_blocks"></a> [super\_net\_cidr\_blocks](#input\_super\_net\_cidr\_blocks) | CIDR blocks for Hub and Spoke super net(s).<br>Must include On-Premises super net(s), if required.<br>if empty, individual VPC cidr blocks will be used for routing that may hit the route table entry limits. | `list(string)` | `[]` | no |
| <a name="input_supported_network_segments"></a> [supported\_network\_segments](#input\_supported\_network\_segments) | List of distinct network segment names for which Transit Gateway route table(s) will be created.<br>transit gateway route tables are always created for the network segments `ALL` and `ISOLATED` | `list(string)` | <pre>[<br>  "ALL",<br>  "ISOLATED"<br>]</pre> | no |
| <a name="input_tgw_cidrs"></a> [tgw\_cidrs](#input\_tgw\_cidrs) | List of CIDRs for the subnet(s) hosting the TGW endpoints.<br>If not provided, it will be calculated at position 2.<br>The recommended CIDR block range is /28. | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_tags"></a> [tgw\_subnet\_tags](#input\_tgw\_subnet\_tags) | Extra tags to add to the transit gw subnet(s) | `map(string)` | `{}` | no |
| <a name="input_tgw_tags"></a> [tgw\_tags](#input\_tgw\_tags) | Extra tags to add to the transit gateway. | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Extra tags to add to the Networks Shared Services (NSS) VPC.<br>These will be carried forward to all subnets too. | `map(string)` | `{}` | no |
| <a name="input_vpce_cidrs"></a> [vpce\_cidrs](#input\_vpce\_cidrs) | List of CIDRs for the subnet(s) hosting the VPC endpoint(s) for the supported AWS Services.<br>If not provided, it will be calculated at position 3.<br>The recommended CIDR block range is /24. | `list(string)` | `[]` | no |
| <a name="input_vpce_flow_log_service_codes"></a> [vpce\_flow\_log\_service\_codes](#input\_vpce\_flow\_log\_service\_codes) | List of the service codes for the supported AWS Services for which flow log will be enabled.<br>if `enable_vpce_flow_log` is true and `vpce_flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.<br>if `enable_vpce_flow_log` is true and `vpce_flow_log_service_codes` is not empty, flow logs will be enabled at the ENI level for the listed services.<br>if `enable_vpce_flow_log` is false VPC flow logs will be disabled, regardless of `vpce_flow_log_service_codes` | `list(string)` | `[]` | no |
| <a name="input_vpce_service_codes"></a> [vpce\_service\_codes](#input\_vpce\_service\_codes) | List of the service codes for the supported AWS Services for which VPC endpoints will be created.<br>If empty or null, no VPC endpoints will be created. | `list(string)` | `[]` | no |
| <a name="input_vpce_subnet_tags"></a> [vpce\_subnet\_tags](#input\_vpce\_subnet\_tags) | Extra tags to add to the vpc endpoint subnet(s) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | List of AZs where subnets are created. |
| <a name="output_nss_attributes"></a> [nss\_attributes](#output\_nss\_attributes) | Network Shared Services attributes, used by spoke\_vpcs module.<br>`super_net_cidr_blocks`, Super Net CIDR Blocks used for routing.<br>`supported_network_segments`, List of supported network segments by NSS.<br>`nw_shared_svc_prefix_list_id`, Prefix list id for NSS.<br>`nw_segment_prefix_list_ids`, Prefix list id for network segment(s).<br>`nw_shared_svc_tgw_id`, Transit GW Id that enables network shared services VPC.<br>`nw_shared_svc_tgw_route_table_id`, TGW route table id for the network shared services VPC.<br>`nw_segment_tgw_route_table_ids`, TGW route table id for network segment(s).<br>`vpce_specs`, Map of shareable VPC endpoints by service codes.<br>`hybrid_dns_specs.inbound_dns_resolver_endpoints`, Inbound DNS Resolver Endpoint(s) to be used to configure On-premises DNS server(s)<br>`hybrid_dns_specs.dns_resolver_rules`, DNS resolver rules that are shared. |
| <a name="output_private_subnet_attributes_by_az"></a> [private\_subnet\_attributes\_by\_az](#output\_private\_subnet\_attributes\_by\_az) | List of private subnet attributes by AZ. |
| <a name="output_supported_vpce_service_codes"></a> [supported\_vpce\_service\_codes](#output\_supported\_vpce\_service\_codes) | List of supported service codes for VPC endpoints. |
| <a name="output_vpc_attributes"></a> [vpc\_attributes](#output\_vpc\_attributes) | VPC attributes for the provisioned VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC Id for the provisioned VPC |
<!-- END_TF_DOCS -->
