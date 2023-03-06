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
| <a name="provider_aws.hub"></a> [aws.hub](#provider\_aws.hub) | 4.57.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_connected_vpcs"></a> [connected\_vpcs](#module\_connected\_vpcs) | aws-ia/vpc/aws | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_managed_prefix_list_entry.nss_pl_spoke_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list_entry) | resource |
| [aws_ec2_managed_prefix_list_entry.nw_segment_pl_spoke_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list_entry) | resource |
| [aws_ec2_transit_gateway_route_table_association.vpc_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.spoke_propagation_to_nss_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.spoke_propagation_to_nw_segment_tgw_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_iam_instance_profile.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route53_resolver_rule_association.dnse_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_vpc_association_authorization.vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_vpc_association_authorization) | resource |
| [aws_route53_zone_association.vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |
| [aws_security_group.test_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_ec2_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_cdu_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [local_file.test_ec2](https://registry.terraform.io/providers/hashicorp/local/2.2.3/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nw_shared_svc_attributes"></a> [nw\_shared\_svc\_attributes](#input\_nw\_shared\_svc\_attributes) | Network Shared Service attributes<br>Outputs from the Network Shared Service module.<br>Work with your Network Shared Services (NSS) to identify this. | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name, used as prefix/suffix for resource identification. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources. | `map(string)` | n/a | yes |
| <a name="input_ec2_test_script"></a> [ec2\_test\_script](#input\_ec2\_test\_script) | Name of the test script that can be used to test all ec2 instances created for testing.<br>if not provided, the test script will not be created. | `string` | `null` | no |
| <a name="input_spoke_vpc_specs"></a> [spoke\_vpc\_specs](#input\_spoke\_vpc\_specs) | List of specs for the Spoke VPC(s).<br>- `name_prefix`, mandatory. A short name that will be used to name the VPC.<br>- `env_name`, mandatory. Environment name e.g. dev, prod, used for resource identification.<br>- `cidr_block`, mandatory. CIDR block for the VPC hosting the Network Shared Services (NSS).<br>  The CIDR block should be in the range of /16 to /20.<br>- `az_count`, mandatory. Number of AZs for which subnet(s) are created.<br>  Assumes AZs sorted a-z. Max 6 AZs.<br>- `tags`, optional. Extra tags to add to the VPC. These will be carried forward to all subnets too.<br>  Default: {}.<br>- `network_segment`, optional. network segment name to which spoke vpc will be connected.<br>  Defaults to "ISOLATED", if the provided network segment is not supported by NSS.<br>  Default: "ISOLATED"<br>- `enable_centralized_vpc_endpoints`, optional. Should the NSS `Centralized VPC Endpoints` be enabled for the Spoke VPC?<br>  Default: false<br>- `vpce_service_codes`, optional. List of supported service codes for which the `Centralized VPC Endpoints` is enabled for the Spoke VPC.<br>  If empty, all the enabled VPC Endpoints by the NSS are enabled for the Spoke VPC.<br>  If contains any service code that is not yet enabled by NSS, it will not be enabled for the Spoke VPC.<br>- `enable_hybrid_dns`, optional. Should the NSS `Hybrid DNS` be enabled for the Spoke VPC?<br>  Default: false<br>- `enable_centralized_egress_to_internet`, optional. Should the NSS `Centralized Egress to Internet` be enabled for the Spoke VPC?<br>  Default: false<br>  Note: **not yet implemented, must use false**<br>- `enable_centralized_ingress_from_internet`, optional. Should the NSS `Centralized Ingress from Internet` be enabled for the Spoke VPC?<br>  Default: false<br>  Note: **not yet implemented, must use false**<br>- `create_test_ec2`, optional. Should a test EC2 instance be created in all the subnets of the Spoke VPC?<br>  Default: false<br>- `subnets`, mandatory.  = List of specs for the Subnet(s) in the Spoke VPC.<br>  - `name_prefix`, mandatory. A short name that will be used to name the subnet.<br>  - `cidrs`, mandatory. List of CIDRs for the subnet(s).<br>    Length of the list must be greater of equal to the `az_count` for the Spoke VPC.<br>  - `type`, mandatory. Type of the subnet.<br>    Must be "public", "private" or "transit\_gateway"<br>    For the Spoke VPC to be of any practical use, it must have at least one "transit\_gateway" (/28) subnet and one "private" subnet.<br>    Default: "private"<br>  - `tags`, optional. Extra tags to add to the subnet.<br>    Default: {}. | <pre>list(object({<br>    name_prefix                              = string<br>    env_name                                 = string<br>    cidr_block                               = string<br>    az_count                                 = number<br>    tags                                     = optional(map(string), {})<br>    network_segment                          = optional(string, "")<br>    enable_centralized_vpc_endpoints         = optional(bool, true)<br>    vpce_service_codes                       = optional(list(string), [])<br>    enable_hybrid_dns                        = optional(bool, true)<br>    enable_centralized_egress_to_internet    = optional(bool, false)<br>    enable_centralized_ingress_from_internet = optional(bool, false)<br>    create_test_ec2                          = optional(bool, false)<br>    subnets = list(object({<br>      name_prefix = string<br>      cidrs       = list(string)<br>      type        = string<br>      tags        = optional(map(string), {})<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_test_ec2_instances"></a> [test\_ec2\_instances](#output\_test\_ec2\_instances) | List of test EC2 instances |
| <a name="output_vpc_dns_resolver_rule_assoc"></a> [vpc\_dns\_resolver\_rule\_assoc](#output\_vpc\_dns\_resolver\_rule\_assoc) | List of DNS resolver rules associations with VPCs. |
| <a name="output_vpc_vpce_phz_assoc"></a> [vpc\_vpce\_phz\_assoc](#output\_vpc\_vpce\_phz\_assoc) | List of private hosted zone associations with VPCs. |
<!-- END_TF_DOCS -->
