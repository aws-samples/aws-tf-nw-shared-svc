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
| [aws_ec2_transit_gateway.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ram_principal_association.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_principal_association.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_principal_association.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod, used for resource identification. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name, used as prefix/suffix for resource identification. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources. | `map(string)` | n/a | yes |
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | Private Autonomous System Number (ASN) for the Amazon side of a BGP session. | `string` | `"64512"` | no |
| <a name="input_share_with_accounts"></a> [share\_with\_accounts](#input\_share\_with\_accounts) | Share the services with list of AWS Accounts. like 111111111111<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>Provided list of AWS Account Ids that are not part of any AWS Organizations OUs in the `share_with_ous`<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_share_with_org"></a> [share\_with\_org](#input\_share\_with\_org) | Share the services at the Organization level.<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>If `share_with_org` is true then `share_with_accounts` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `bool` | `true` | no |
| <a name="input_share_with_ous"></a> [share\_with\_ous](#input\_share\_with\_ous) | Share the services with list of AWS Organizations OU, like ou-xyz-abcdefg<br>If `share_with_org` is true then `share_with_ous` is ignored.<br>The master account for the AWS Organization must have enabled sharing in the AWS Resource Access Manager (RAM).<br>e.g. `aws ram enable-sharing-with-aws-organization` | `list(string)` | `[]` | no |
| <a name="input_tgw_tags"></a> [tgw\_tags](#input\_tgw\_tags) | Extra tags to add to the transit gateway resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tgw_id"></a> [tgw\_id](#output\_tgw\_id) | Transit GW Id for the provisioned TGW |
<!-- END_TF_DOCS -->
