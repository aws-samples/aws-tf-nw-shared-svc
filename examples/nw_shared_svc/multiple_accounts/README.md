# Scenario: Provision Network Shared Services (NSS) VPC in the `network` account of the AWS Organization.

This example demonstrates provisioning of Network Shared Services (NSS) VPC in the `network` account with following features:
- Named Network Segments for VPC to VPC connectivity.
    - "DEV",
    - "TEST",
    - "FINANCE",
    - "OPERATIONS"
- Organization level (default) sharing of NSS resources.
- Centralized VPC private endpoints for the following AWS Services
    - "ec2",
    - "ec2messages",
    - "ssm",
    - "ssmmessages",
    - "s3",
- Centralized hybrid DNS for simulated on-premises environment.

## Prerequisites
- The target AWS Account(s) (e.g. Tooling, Network, and spoke VPC accounts) and AWS Region are identified.
- The master account for the AWS Organization must have enabled sharing in the [AWS Resource Access Manager (RAM)](https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html).
    - e.g. `aws ram enable-sharing-with-aws-organization`
- Terraform backend provider and state locking providers are identified and bootstrapped in the `tooling` account.
  - A [bootstrap](../../bootstrap) example is provided that provisions an Amazon S3 bucket for Terraform state storage and Amazon DynamoDB table for Terraform state locking.
    - The Amazon S3 bucket name must be globally unique.
- `Terraformer` IAM role is bootstrapped in each of the target AWS account e.g. `network`.
  - A [bootstrap](../../bootstrap) example is provided that provisions the `Terraformer` role in the target AWS accounts (`network`, `sec`, `dev`, `test`).
- Uniform resource tagging scheme is identified.
  - The examples use only two tags: `Env` and `Project`

## Execution
- cd to `examples/nw_shared_svc/multiple_accounts` folder.
- Make sure you are using the correct AWS Profile that has permission to provision the target resources in the `network` account. e.g. "tooling-admin"
    - `aws sts get-caller-identity`
- Modify `terraform.tfvars` to your requirements.
    - Use provided values as guidance.
- Modify `provider.tf` as per your environment.
    - Make sure `data.terraform_remote_state.bootstrap` points to the correct `bootstrap` terraform state.
- Modify `main.tf` to your requirements.
    - Use provided values as guidance.
    - Try different features of the module or add more VPC endpoints.
- Execute `terraform init` to initialize Terraform.
- Execute `terraform plan` and verify the changes.
- Execute `terraform apply` and approve the changes.
- Examine the `outputs` and provisioned resources in the AWS Console of the `network` account.
    - VPC, subnets, route tables (routes), and NAT Gateway(s)
    - Prefix lists for the network segments and entries
    - VPC Endpoints and related subnets, and security groups
    - Route 53 hosted zones, records, and VPC associations
    - Transit Gateway and TGW route tables (associations and propagations)
    - Route 53 DNS resolvers, endpoints, rules, and related security groups
    - RAM resource shares and shared resources

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.56.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nw_shared_svc"></a> [nw\_shared\_svc](#module\_nw\_shared\_svc) | ../../../modules/aws/nw_shared_svc | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name e.g. dev, prod | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project to be used on all the resources identification | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mandatory tags for the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | List of AZs where subnets are created. |
| <a name="output_nss_attributes"></a> [nss\_attributes](#output\_nss\_attributes) | Network Shared Services attributes, used by spoke\_vpcs module. |
| <a name="output_private_subnet_attributes_by_az"></a> [private\_subnet\_attributes\_by\_az](#output\_private\_subnet\_attributes\_by\_az) | List of private subnet attributes by AZ. |
| <a name="output_vpc_attributes"></a> [vpc\_attributes](#output\_vpc\_attributes) | VPC attributes for the provisioned VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC Id for the provisioned VPC |
<!-- END_TF_DOCS -->
