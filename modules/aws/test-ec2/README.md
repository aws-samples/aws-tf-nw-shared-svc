# VPC Test EC2

This module creates test EC2 instances in the given VPC(s)/Subnet(s) and generated test script to allow connectivity test from EC2 instance(s) and/or on-premises server(s).

## Example

```hcl
module "test_connectivity" {
  source = "./modules/aws/test-ec2"

  vpcs = [
    {
      vpc_name = "vpc_dev"
      vpc_id   = "vpc-0123456789abcdef0"
      vpc_role = "dev"
      subnet_ids = ["10.168.16.0/22", "10.168.20.0/22"]
      create_test_ec2 = true
    },
    {
      vpc_name = "vpc_stg"
      vpc_id   = "vpc-1234567890abcdef0"
      vpc_role = "stg"
      subnet_ids = ["10.168.24.0/22", "10.168.28.0/22"]
      create_test_ec2 = true
    }
  ]

  vpce_cidrs = ["10.199.1.0/24", "10.199.2.0/24"]

  vpce_services = [
    "s3",
    "dynamodb",
    "ec2",
    "ssm",
    "ssmmessages",
    "secretsmanager",
    "mgn"
  ]

  instance_type = "t4g.micro"
  instance_architecture = ["arm64"]
  instance_volume_type = ["gp2"]
}
```

## Notes

1. Prerequisites:
   - The VPC(s)/Subnet(s) must exist
2. Account Access:
   - The generated scripts allow test from all/some EC2 instances.
   - The AWS CLI access to the source account must be setup in the current shell.

## Usage
Execute `./resources/test-connectivity-from-ec2.sh` with the source account credentials in the current shell
```bash
./resources/test-connectivity-from-ec2.sh
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.67 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.80.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.test_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_test_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_test_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [local_file.test_ec2_from_ec2](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.test_ec2_json](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.test_ec2_sh](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_ami.test_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_instance_profile.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_iam_policy.ec2_ro_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.s3_full_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ssm_managed_instance_core_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ec2_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_architecture"></a> [instance\_architecture](#input\_instance\_architecture) | Instance architecture e.g. x86\_64, arm64 | `list(string)` | <pre>[<br/>  "x86_64",<br/>  "arm64"<br/>]</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type e.g. t2.micro, t3.micro | `string` | `"t3.micro"` | no |
| <a name="input_instance_volume_type"></a> [instance\_volume\_type](#input\_instance\_volume\_type) | Volume type e.g. gp2, gp3 | `list(string)` | <pre>[<br/>  "gp2",<br/>  "gp3",<br/>  "io1",<br/>  "iop2"<br/>]</pre> | no |
| <a name="input_vpce_cidrs"></a> [vpce\_cidrs](#input\_vpce\_cidrs) | List of common CIDR blocks where VPC endpoints are hosted in each VPC | `list(string)` | `[]` | no |
| <a name="input_vpce_services"></a> [vpce\_services](#input\_vpce\_services) | List of AWS Service codes e.g. s3, dynamodb, for which VPC endpoints need to be tested | `list(string)` | `[]` | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | List of VPCs where test ec2 instances will be created | <pre>list(object({<br/>    vpc_name        = string<br/>    vpc_id          = string<br/>    vpc_role        = string<br/>    subnet_ids      = list(string)<br/>    create_test_ec2 = optional(bool, false)<br/>    tags            = optional(map(string))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_test_ec2_instances"></a> [test\_ec2\_instances](#output\_test\_ec2\_instances) | List of test EC2 instances |
| <a name="output_test_iam_instance_profile"></a> [test\_iam\_instance\_profile](#output\_test\_iam\_instance\_profile) | test IAM instance profile |
| <a name="output_test_iam_role"></a> [test\_iam\_role](#output\_test\_iam\_role) | test IAM role |
| <a name="output_test_sg"></a> [test\_sg](#output\_test\_sg) | test security groups |
<!-- END_TF_DOCS -->
