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
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpce_kms"></a> [vpce\_kms](#module\_vpce\_kms) | github.com/aws-samples/aws-tf-kms//modules/aws/kms | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.vpce_eni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_flow_log.vpce_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.flow_log_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_log_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_route53_record.vpce_phz](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.vpce_phz_wildcard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.vpce_phz](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_s3_bucket.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.vpce_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.vpce_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_vpce_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_vpce_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_endpoint.shared_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [local_file.test_vpce](https://registry.terraform.io/providers/hashicorp/local/2.2.3/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod, used for resource identification. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name, used as prefix/suffix for resource identification. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources. | `map(string)` | n/a | yes |
| <a name="input_az_to_subnets"></a> [az\_to\_subnets](#input\_az\_to\_subnets) | Map of Availability Zone to target subnet(s) to host the VPC Endpoint(s).<br>Other options is to provide the mutually exclusive `subnet_tags` to discover target subnet(s) in the VPC.<br>Either `subnet_tags` or `az_to_subnets` must be provided.<br>If both are provided `az_to_subnets` is used. | <pre>map(object({<br>    id         = string<br>    cidr_block = string<br>    az_id      = string<br>  }))</pre> | `{}` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Enable VPC flow log for all the VPC endpoints, unless overridden by `flow_log_service_codes`.<br>if true and `flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.<br>if false VPC flow logs will be disabled. | `bool` | `false` | no |
| <a name="input_flow_log_service_codes"></a> [flow\_log\_service\_codes](#input\_flow\_log\_service\_codes) | List of the service codes for the supported AWS Services for which flow log will be enabled.<br>if `enable_flow_log` is true and `flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.<br>if `enable_flow_log` is true and `flow_log_service_codes` is not empty, flow logs will be enabled at the ENI level for the listed services.<br>if `enable_flow_log` is false VPC flow logs will be disabled, regardless of `flow_log_service_codes` | `list(string)` | `[]` | no |
| <a name="input_flow_log_specs"></a> [flow\_log\_specs](#input\_flow\_log\_specs) | Options to customize the VPC flow logs, effective if `enable_flow_log` is true.<br>- `destination_type`, optional. Valid values: cloud-watch-logs or s3. default: cloud-watch-logs<br>- `destination_name`, optional. Provide an existing `destination_name`.<br>  For `destination_type` s3, provide an existing s3 bucket name<br>  For `destination_type` cloud-watch-logs, provide an existing cloudwatch log group<br>  If not provided, a destination will be created based on the `destination_type`<br>- `encrypted`, optional. Should the flow logs be encrypted. default: `true`<br>  Not applicable, if `destination_name` is provided.<br>- `kms_alias`, optional. Provide an existing `kms_alias` to encrypt the flow logs.<br>  If not provided, an appropriate KMS is created based on the `destination_type`<br>  Not applicable, if `encrypted` is false or `destination_name` is provided.<br>- `flow_log_role`, optional. Provide an existing IAM role for the flow log with permissions to log to `destination_type`<br>  If not provided, an appropriate IAM role is created with permissions to log to `destination_type`<br>`traffic_type`, optional. Type for traffic to capture in the flow log. ACCEPT, REJECT, or ALL. Default is ALL<br>`max_aggregation_interval`, optional. Max aggregation interval for the flow log capture before sending to destination. 600 or 60. Default is 600<br>`file_format`, optional. if `destination_type` is s3, provide one of the supported file formats. plain-text or parquet. Default is plain-text<br>`per_hour_partition`, optional. if `destination_type` is s3, should one hour partition be created. Default is false<br>`hive_compatible_partitions`, optional. if `destination_type` is s3, should hive compatible partition be created. Default is false | <pre>object({<br>    destination_type           = optional(string, "cloud-watch-logs")<br>    destination_name           = optional(string, "")<br>    encrypted                  = optional(bool, true)<br>    kms_alias                  = optional(string, "")<br>    flow_log_role              = optional(string, "")<br>    traffic_type               = optional(string, "ALL")<br>    max_aggregation_interval   = optional(number, 600)<br>    file_format                = optional(string, "plain-text")<br>    per_hour_partition         = optional(bool, false)<br>    hive_compatible_partitions = optional(bool, false)<br>  })</pre> | <pre>{<br>  "destination_name": "",<br>  "destination_type": "cloud-watch-logs",<br>  "encrypted": true,<br>  "file_format": "plain-text",<br>  "flow_log_role": "",<br>  "hive_compatible_partitions": false,<br>  "kms_alias": "",<br>  "max_aggregation_interval": 600,<br>  "per_hour_partition": false,<br>  "traffic_type": "ALL"<br>}</pre> | no |
| <a name="input_generate_vpce_test_script"></a> [generate\_vpce\_test\_script](#input\_generate\_vpce\_test\_script) | Generate a test script that can be used to test all the provisioned VPC endpoints. | `bool` | `false` | no |
| <a name="input_kms_admin_roles"></a> [kms\_admin\_roles](#input\_kms\_admin\_roles) | List Administrator roles for KMS.<br>Provide at least one Admin role if kms needs to be created for the encryption of VPC flow logs e.g. ["Admin"].<br>It can be empty if `enable_flow_log` is false.<br>It can be empty if `enable_flow_log` is true but `flow_log_specs.encrypted` is false. | `list(string)` | `[]` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | Tags to discover target subnets in the VPC, these tags should identify one or more subnets to host the VPC Endpoint(s).<br>Other option is to provide the mutually exclusive `az_to_subnets` for the target subnets.<br>Either `subnet_tags` or `az_to_subnets` must be provided.<br>If both are provided `az_to_subnets` is used. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Identifies the target VPC to host the VPC Endpoint(s).<br>Other option is to provide the mutually exclusive `vpc_tags` to discover the VPC.<br>Either `vpc_tags` or `vpc_id` must be provided.<br>If both are provided `vpc_id` is used. | `string` | `null` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to discover target VPC, these tags should uniquely identify a VPC to host the VPC Endpoint(s).<br>Other option is to provide the mutually exclusive `vpc_id`.<br>Either `vpc_tags` or `vpc_id` must be provided.<br>If both are provided `vpc_id` is used. | `map(string)` | `{}` | no |
| <a name="input_vpce_service_codes"></a> [vpce\_service\_codes](#input\_vpce\_service\_codes) | List of the service codes for the supported AWS Services for which VPC endpoints will be created. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_supported_service_codes"></a> [supported\_service\_codes](#output\_supported\_service\_codes) | List of supported service codes for this module. |
| <a name="output_vpce_specs"></a> [vpce\_specs](#output\_vpce\_specs) | The detail about the created VPC Endpoints. |
<!-- END_TF_DOCS -->
