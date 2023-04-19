<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.56.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.admin"></a> [aws.admin](#provider\_aws.admin) | 4.63.0 |
| <a name="provider_aws.delegated"></a> [aws.delegated](#provider\_aws.delegated) | 4.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_role.delegate_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.delegated_terraform_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_delegated_access_only"></a> [delegated\_access\_only](#input\_delegated\_access\_only) | When `delegated_access_only` is true, only delegated access role is created. | `bool` | `false` | no |
| <a name="input_delegated_access_policy"></a> [delegated\_access\_policy](#input\_delegated\_access\_policy) | Provide (optional) policy for the delegated Terraform role. Otherwise "AdministratorAccess" will be assumed. | `string` | `null` | no |
| <a name="input_delegated_role_name"></a> [delegated\_role\_name](#input\_delegated\_role\_name) | Provide (optional) name for the delegated Terraform role. Otherwise `Terraformer` will be assumed. | `string` | `"Terraformer"` | no |
| <a name="input_dynamo_locktable_name"></a> [dynamo\_locktable\_name](#input\_dynamo\_locktable\_name) | Name of the DynamoDB table used for Terraform state locking. If not provided, table will not be created. | `string` | `null` | no |
| <a name="input_s3_statebucket_name"></a> [s3\_statebucket\_name](#input\_s3\_statebucket\_name) | Name of the S3 bucket used for storing Terraform state files. If not provided, bucket will not be created. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common and mandatory tags for the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_config"></a> [backend\_config](#output\_backend\_config) | Define the backend configuration with following values |
| <a name="output_delegated_role_arn"></a> [delegated\_role\_arn](#output\_delegated\_role\_arn) | Delegated Role ARN |
<!-- END_TF_DOCS -->
