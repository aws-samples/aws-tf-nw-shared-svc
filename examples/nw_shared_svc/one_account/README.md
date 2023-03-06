# Scenario: Provision Network Shared Services (NSS) VPC in an AWS Account

This example demonstrates provisioning of Network Shared Services (NSS) VPC in an AWS Account with following features:
- Named Network Segments for VPC to VPC connectivity.
    - "DEV",
    - "TEST"
- Resource Access Manager (RAM) sharing is disabled or not being used.
- Centralized VPC private endpoints for the following AWS Services
    - "ec2",
    - "ec2messages",
    - "ssm",
    - "ssmmessages",
    - "s3",
- Centralized hybrid DNS for simulated on-premises environment.

## Prerequisites
- The target AWS Account (e.g. Dev) and AWS Region are identified.
- Terraform backend provider and state locking providers are identified and bootstrapped.
  - A [bootstrap](../../bootstrap) example is provided that provisions an Amazon S3 bucket for Terraform state storage and Amazon DynamoDB table for Terraform state locking.
    - The Amazon S3 bucket name must be globally unique.
- Uniform resource tagging scheme is identified.
  - The examples use only two tags: `Env` and `Project`

## Execution
- cd to `examples/nw_shared_svc/one_account` folder.
- Make sure you are using the correct AWS Profile that has permission to provision the target resources in the target account.
    - `aws sts get-caller-identity`
- Modify `terraform.tfvars` to your requirements.
    - Use provided values as guidance.
- Modify `provider.tf` as per your environment.
    - Use provided values as guidance.
- Modify `main.tf` to your requirements.
    - Use provided values as guidance.
    - Try different features of the module or add more VPC endpoints.
- Execute `terraform init` to initialize Terraform.
- Execute `terraform plan` and verify the changes.
- Execute `terraform apply` and approve the changes.
- Examine the `outputs` and provisioned resources in the AWS Console.
    - VPC, subnets, route tables (routes), and NAT Gateway(s)
    - Prefix lists for the network segments and entries
    - VPC Endpoints and related subnets, and security groups
    - Route 53 hosted zones, records, and VPC associations
    - Transit Gateway and TGW route tables (associations and propagations)
    - Route 53 DNS resolvers, endpoints, rules, and related security groups

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.56.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nw_shared_svc"></a> [nw\_shared\_svc](#module\_nw\_shared\_svc) | ../../../modules/aws/nw_shared_svc | n/a |

## Resources

No resources.

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
