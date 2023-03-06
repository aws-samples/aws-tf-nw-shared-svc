# Scenario: Provision Spoke VPCs in an AWS Account.

This example demonstrates provisioning of multiple Spoke VPCs in an AWS Account with different connectivity and usage of Network Shared Services (NSS).
- Spoke VPC "dev-app1"
    - Three tier subnets to support hosting web (public), app (private) and db (private) resources.
    - VPC to VPC connectivity via "DEV" network segment.
        - Connectivity with the VPC "dev-app2"
        - No connectivity with the VPC "dev-app3"
    - Enable usage of all available VPC endpoints
    - Enable usage of hybrid DNS for DNS resolution with on-premises DNS servers.
- Spoke VPC "dev-app2"
    - Three tier subnets to support hosting web (public), app (private) and db (private) resources.
    - VPC to VPC connectivity via "DEV" network segment.
        - Connectivity with the VPC "dev-app1"
        - No connectivity with the VPC "dev-app3"
    - Enable usage of only "S3" VPC endpoint.
    - Enable usage of hybrid DNS for DNS resolution with on-premises DNS servers.
- Spoke VPC "dev-app3"
    - Three tier subnets to support hosting web (public), app (private) and db (private) resources.
    - VPC to VPC connectivity via "ISOLATED" network segment.
        - No connectivity with any other VPC except on-premises and NSS VPC
    - Enable usage of all available VPC endpoints
    - Enable usage of hybrid DNS for DNS resolution with on-premises DNS servers.

This example can be modified to create more VPCs in the AWS Account with different features.

## Prerequisites
- The target AWS Account (e.g. Dev) and AWS Region are identified.
- Terraform backend provider and state locking providers are identified and bootstrapped.
  - A [bootstrap](../../bootstrap) example is provided that provisions an Amazon S3 bucket for Terraform state storage and Amazon DynamoDB table for Terraform state locking.
    - The Amazon S3 bucket name must be globally unique.
- The centralized NSS VPC is created in the same AWS account to which these spoke VPCs will be connected.
    - A [nw_shared_svc/one-account](../../nw_shared_svc/one_account) example is provided that provisions the NSS VPC.
- Uniform resource tagging scheme is identified.
  - The examples use only two tags: `Env` and `Project`

## Execution
- cd to `examples/spoke_vpcs/one_account` folder.
- Make sure you are using the correct AWS Profile that has permission to provision the target resources in the target account.
    - `aws sts get-caller-identity`
- Modify `terraform.tfvars` to your requirements.
    - Use provided values as guidance.
- Modify `provider.tf` as per your environment.
    - Make sure `data.terraform_remote_state.nw_shared_svc` points to the correct `nw_shared_svc` terraform state.
- Modify `main.tf` to your requirements.
    - Use provided values as guidance.
    - Try different features of the module or add more VPCs.
- Execute `terraform init` to initialize Terraform.
- Execute `terraform plan` and verify the changes.
- Execute `terraform apply` and approve the changes.
- Examine the `outputs` and provisioned resources in the AWS Console of the target account.
    - VPC, subnets, route tables (routes) and NAT Gateway(s)
    - Prefix lists for the network segments and entries.
    - Transit Gateway and attachments
    - TGW route tables associations and propagations
    - Route 53 DNS resolvers rules and VPC association
    - Route 53 hosted zones and VPC associations

## Validate VPC to VPC and VPC to VPC Endpoint connectivity
While creating NSS VPC with VPC endpoints:
- if `generate_vpce_test_script` is "true" then a test shell script is created for testing connectivity to VPC endpoints in `.temp` folder.

While creating Spoke VPCs:
- if `create_test_ec2` (at VPC level) is "true" then a `t2.micro` instance is created in each subnet of the VPC for testing.
- if `ec2_test_script` (at module level) is specified then a test shell script is created for testing connectivity in `.temp` folder.

Connect to any of the test EC2 instances via AWS Console or AWS CLI/SSM and execute these scripts to validate the VPC to VPC and VPC to VPC endpoint connectivity.

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
| <a name="module_connected_vpcs"></a> [connected\_vpcs](#module\_connected\_vpcs) | ../../../modules/aws/spoke_vpcs | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | Project to be used on all the resources identification | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region e.g. us-east-1 for the environment | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mandatory tags for the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_dns_resolver_rule_assoc"></a> [vpc\_dns\_resolver\_rule\_assoc](#output\_vpc\_dns\_resolver\_rule\_assoc) | List of DNS resolver rules associations with VPCs. |
| <a name="output_vpc_vpce_phz_assoc"></a> [vpc\_vpce\_phz\_assoc](#output\_vpc\_vpce\_phz\_assoc) | List of private hosted zone associations with VPCs. |
<!-- END_TF_DOCS -->
