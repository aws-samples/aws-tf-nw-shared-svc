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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_shared_services_vpc"></a> [shared\_services\_vpc](#module\_shared\_services\_vpc) | aws-ia/vpc/aws | >= 4.0.0 |
| <a name="module_shared_tgw"></a> [shared\_tgw](#module\_shared\_tgw) | ../transit_gw | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_managed_prefix_list.nss_pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list) | resource |
| [aws_ec2_managed_prefix_list.nw_segment_pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list) | resource |
| [aws_ec2_managed_prefix_list_entry.nss_pl_nss_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list_entry) | resource |
| [aws_ec2_managed_prefix_list_entry.nw_segment_pl_nss_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list_entry) | resource |
| [aws_ec2_transit_gateway_route_table.nss_vpc_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.nw_segment_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.nss_vpc_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.nss_propagation_to_nw_segment_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ram_principal_association.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_principal_association.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_principal_association.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.nss_pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_association.nw_segment_pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.pl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the VPC hosting the Network Shared Services (NSS).<br>The CIDR block should be in the range of /16 to /20 | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod, used for resource identification. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name, used as prefix/suffix for resource identification. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources. | `map(string)` | n/a | yes |
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | Private Autonomous System Number (ASN) for the Amazon side of a BGP session. | `string` | `"64512"` | no |
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Number of AZs to spread the Networks Shared Services (NSS) to.<br>Assumes AZs sorted a-z. Max 6 AZs. | `number` | `3` | no |
| <a name="input_dnse_cidrs"></a> [dnse\_cidrs](#input\_dnse\_cidrs) | List of CIDRs for the subnet(s) hosting the DNS resolver endpoint(s).<br>If not provided, it will be calculated at position 4.<br>The recommended CIDR block range is /28. | `list(string)` | `[]` | no |
| <a name="input_dnse_subnet_tags"></a> [dnse\_subnet\_tags](#input\_dnse\_subnet\_tags) | Extra tags to add to the dns resolver endpoint subnet(s) | `map(string)` | `{}` | no |
| <a name="input_enable_dnse"></a> [enable\_dnse](#input\_enable\_dnse) | If enabled, subnet(s) for DNS resolver endpoints will be created. | `bool` | `false` | no |
| <a name="input_enable_vpce"></a> [enable\_vpce](#input\_enable\_vpce) | If enabled, subnet(s) for VPC endpoints will be created. | `bool` | `false` | no |
| <a name="input_nat_gateway_config"></a> [nat\_gateway\_config](#input\_nat\_gateway\_config) | NAT Gateways spread to be created.<br>Network Shared Services (NSS) requires NAT GW. Valid values = "single\_az", "all\_azs"<br>There is soft limit of 5 EIPs per VPC per account. | `string` | `"single_az"` | no |
| <a name="input_public_cidrs"></a> [public\_cidrs](#input\_public\_cidrs) | List of CIDRs for the public subnet(s) hosting the NAT GW.<br>If not provided, it will be calculated at position 1. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Extra tags to add to the public subnet(s) | `map(string)` | `{}` | no |
| <a name="input_share_with_accounts"></a> [share\_with\_accounts](#input\_share\_with\_accounts) | Share the services with list of AWS Accounts. like 111111111111<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>Provided list of AWS Account Ids that are not part of any AWS Organizations OUs in the `share_with_ous`<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_share_with_org"></a> [share\_with\_org](#input\_share\_with\_org) | Share the services at the Organization level.<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `bool` | `true` | no |
| <a name="input_share_with_ous"></a> [share\_with\_ous](#input\_share\_with\_ous) | Share the services with list of AWS Organizations OU, like ou-xyz-abcdefg<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_super_net_cidr_blocks"></a> [super\_net\_cidr\_blocks](#input\_super\_net\_cidr\_blocks) | CIDR blocks for Hub and Spoke super net(s).<br>Must include On-Premises super net(s), if required.<br>if empty, individual VPC cidr blocks will be used for routing that may hit the route table entry limits. | `list(string)` | `[]` | no |
| <a name="input_supported_network_segments"></a> [supported\_network\_segments](#input\_supported\_network\_segments) | List of distinct network segment names for which Transit Gateway route table(s) will be created.<br>transit gateway route tables are always created for the network segments `ALL` and `ISOLATED` | `list(string)` | <pre>[<br>  "ALL",<br>  "ISOLATED"<br>]</pre> | no |
| <a name="input_tgw_cidrs"></a> [tgw\_cidrs](#input\_tgw\_cidrs) | List of CIDRs for the subnet(s) hosting the TGW endpoints.<br>If not provided, it will be calculated at position 2.<br>The recommended CIDR block range is /28. | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_tags"></a> [tgw\_subnet\_tags](#input\_tgw\_subnet\_tags) | Extra tags to add to the transit gw subnet(s) | `map(string)` | `{}` | no |
| <a name="input_tgw_tags"></a> [tgw\_tags](#input\_tgw\_tags) | Extra tags to add to the transit gateway. | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Extra tags to add to the Networks Shared Services (NSS) VPC.<br>These will be carried forward to all subnets too. | `map(string)` | `{}` | no |
| <a name="input_vpce_cidrs"></a> [vpce\_cidrs](#input\_vpce\_cidrs) | List of CIDRs for the subnet(s) hosting the VPC endpoint(s) for the supported AWS Services.<br>If not provided, it will be calculated at position 3.<br>The recommended CIDR block range is /24. | `list(string)` | `[]` | no |
| <a name="input_vpce_subnet_tags"></a> [vpce\_subnet\_tags](#input\_vpce\_subnet\_tags) | Extra tags to add to the vpc endpoint subnet(s) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | List of AZs where subnets are created. |
| <a name="output_nw_segment_prefix_list_ids"></a> [nw\_segment\_prefix\_list\_ids](#output\_nw\_segment\_prefix\_list\_ids) | Prefix list id for network segment(s). |
| <a name="output_nw_segment_tgw_route_table_ids"></a> [nw\_segment\_tgw\_route\_table\_ids](#output\_nw\_segment\_tgw\_route\_table\_ids) | TGW route table id for network segment(s). |
| <a name="output_nw_shared_svc_prefix_list_id"></a> [nw\_shared\_svc\_prefix\_list\_id](#output\_nw\_shared\_svc\_prefix\_list\_id) | Prefix list id for NSS. |
| <a name="output_nw_shared_svc_tgw_attachment_id"></a> [nw\_shared\_svc\_tgw\_attachment\_id](#output\_nw\_shared\_svc\_tgw\_attachment\_id) | TGW attachment id for network shared services VPC. |
| <a name="output_nw_shared_svc_tgw_id"></a> [nw\_shared\_svc\_tgw\_id](#output\_nw\_shared\_svc\_tgw\_id) | Transit GW Id that enables network shared services VPC. |
| <a name="output_nw_shared_svc_tgw_route_table_id"></a> [nw\_shared\_svc\_tgw\_route\_table\_id](#output\_nw\_shared\_svc\_tgw\_route\_table\_id) | TGW route table id for network shared services VPC. |
| <a name="output_private_subnet_attributes_by_az"></a> [private\_subnet\_attributes\_by\_az](#output\_private\_subnet\_attributes\_by\_az) | List of private subnet attributes by AZ. |
| <a name="output_super_net_cidr_blocks"></a> [super\_net\_cidr\_blocks](#output\_super\_net\_cidr\_blocks) | Super Net CIDR Blocks used for routing. |
| <a name="output_supported_network_segments"></a> [supported\_network\_segments](#output\_supported\_network\_segments) | List of supported network segments by NSS. |
| <a name="output_vpc_attributes"></a> [vpc\_attributes](#output\_vpc\_attributes) | VPC attributes for the provisioned VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC Id for the provisioned VPC |
<!-- END_TF_DOCS -->
