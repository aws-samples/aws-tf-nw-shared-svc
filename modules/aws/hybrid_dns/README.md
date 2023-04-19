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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_principal_association.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_principal_association.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.dnse_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.dnse_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route53_resolver_endpoint.dnse_in](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_endpoint.dnse_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.dnse_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule_association.dnse_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_security_group.dnse_in](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.dnse_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.dnse_in_egress_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.dnse_in_egress_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.dnse_out_egress_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.dnse_out_egress_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod, used for resource identification. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name, used as prefix/suffix for resource identification. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources. | `map(string)` | n/a | yes |
| <a name="input_dnse_tags"></a> [dnse\_tags](#input\_dnse\_tags) | Extra tags to add to the DNS resolver endpoints. | `map(string)` | `{}` | no |
| <a name="input_on_premises_cidrs"></a> [on\_premises\_cidrs](#input\_on\_premises\_cidrs) | List of on-premises CIDR blocks that will use inbound DNS resolver endpoint.<br>Check for the output `inbound_dns_resolver_endpoints`, for configuring on-premises DNS server(s). | `list(string)` | `[]` | no |
| <a name="input_outbound_dns_resolver_config"></a> [outbound\_dns\_resolver\_config](#input\_outbound\_dns\_resolver\_config) | List of outbound DNS resolver configurations.<br>If specified, outbound resolver endpoint(s) along with forward rules will be created.<br>`domain_name`, mandatory. On-premises domain name, for which DNS query will be forwarded to the `target_ip_addresses`<br>`target_ip_addresses`. mandatory. On-premises DNS server IP address. | <pre>list(object({<br>    domain_name         = string<br>    target_ip_addresses = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_share_with_accounts"></a> [share\_with\_accounts](#input\_share\_with\_accounts) | Share the services with list of AWS Accounts. like 111111111111<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>Provided list of AWS Account Ids that are not part of any AWS Organizations OUs in the `share_with_ous`<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_share_with_org"></a> [share\_with\_org](#input\_share\_with\_org) | Share the services at the Organization level.<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `bool` | `true` | no |
| <a name="input_share_with_ous"></a> [share\_with\_ous](#input\_share\_with\_ous) | Share the services with list of AWS Organizations OU, like ou-xyz-abcdefg<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags to discover target subnets in the VPC, these tags should identify one or more subnets to host the DNS resolver Endpoint(s).<br>Other option is to provide the mutually exclusive `subnet_ids` for the target subnets.<br>Either `subnet_tags` or `subnet_ids` must be provided.<br>If both are provided `subnet_ids` is used. | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of target subnet(s) to host the DNS resolver Endpoint(s).<br>Other options is to provide the mutually exclusive `subnet_tags` to discover target subnet(s) in the VPC.<br>Either `subnet_tags` or `subnets` must be provided.<br>If both are provided `subnets` is used. | <pre>list(object({<br>    subnet_id  = string<br>    cidr_block = string<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Identifies the target VPC to host the DNS resolver Endpoint(s).<br>Other option is to provide the mutually exclusive `vpc_tags` to discover the VPC.<br>Either `vpc_tags` or `vpc_id` must be provided.<br>If both are provided `vpc_id` is used. | `string` | `null` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to discover target VPC, these tags should uniquely identify a VPC to host the DNS resolver Endpoint(s).<br>Other option is to provide the mutually exclusive `vpc_id`.<br>Either `vpc_tags` or `vpc_id` must be provided.<br>If both are provided `vpc_id` is used. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hybrid_dns_specs"></a> [hybrid\_dns\_specs](#output\_hybrid\_dns\_specs) | Hybrid DNS specs.<br>`inbound_dns_resolver_endpoints`, Inbound DNS Resolver Endpoint(s) to be used to configure On-premises DNS server(s)<br>`dns_resolver_rules`, DNS resolver rules that are shared. |
<!-- END_TF_DOCS -->
