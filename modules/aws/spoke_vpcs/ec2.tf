#ec2
locals {
  create_test_ec2 = length([for vpc_specs in local.spoke_vpc_specs : "create" if try(vpc_specs.create_test_ec2 == true, false)]) != 0 ? true : false
  vpc_names       = [for vpc_specs in local.spoke_vpc_specs : "${vpc_specs.name_prefix}-${vpc_specs.env_name}" if try(vpc_specs.create_test_ec2 == true, false)]

  private_subnet_ec2 = flatten([
    for vpc_specs in local.spoke_vpc_specs : [
      for subnet in vpc_specs.subnets : [
        for az in slice(data.aws_availability_zones.current.names, 0, vpc_specs.az_count) : {
          vpc_name    = "${vpc_specs.name_prefix}-${vpc_specs.env_name}"
          subnet_name = "${subnet.name_prefix}/${az}"
        }
      ] if subnet.type == "private"
    ] if try(vpc_specs.create_test_ec2 == true, false)
  ])
}

locals {
  generate_ec2_test_script = try(length(var.ec2_test_script), 0) != 0 ? true : false

  ec2_tests = [
    for subnet in local.private_subnet_ec2 :
    "TEST=$(ping -c 1 -W 5 ${aws_instance.private["${subnet.vpc_name}-${subnet.subnet_name}"].private_ip});if [[ \"$TEST\" == *\"1 received\"* ]];then echo \"${aws_instance.private["${subnet.vpc_name}-${subnet.subnet_name}"].private_ip}: Reachable\"; else echo \"${aws_instance.private["${subnet.vpc_name}-${subnet.subnet_name}"].private_ip}: Not-Reachable\"; fi"
  ]
}

data "aws_availability_zones" "current" {}

resource "aws_instance" "private" {
  # checkov:skip=CKV_AWS_8: test instances, no need to encrypt EBS
  # checkov:skip=CKV_AWS_135: test instances, no need to optimize EBS
  # checkov:skip=CKV_AWS_126: test instances, no need for detailed monitoring
  for_each = { for subnet in local.private_subnet_ec2 : "${subnet.vpc_name}-${subnet.subnet_name}" => subnet }

  ami                         = data.aws_ami.test_ami[0].id
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  iam_instance_profile        = data.aws_iam_instance_profile.ec2_role[0].name
  subnet_id                   = module.connected_vpcs[each.value.vpc_name].private_subnet_attributes_by_az[each.value.subnet_name].id
  vpc_security_group_ids      = [aws_security_group.test_sg[each.value.vpc_name].id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = "${each.key}-test-${var.project}"
  }
}

data "aws_ami" "test_ami" {
  count = local.create_test_ec2 ? 1 : 0

  most_recent = true

  owners = ["amazon", "self"]
  #executable_users = ["self"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"] #i386 | x86_64 | arm64
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"] #io1 | io2 | gp2 | gp3 | sc1 | st1 | standard
  }
}

resource "aws_security_group" "test_sg" {
  # checkov:skip=CKV2_AWS_5: SG is attached in the resource module
  # checkov:skip=CKV_AWS_23: N/A
  for_each = toset(local.vpc_names)

  name        = "${var.project}-${each.value}-test-ec2-sg"
  description = "Secure inbound/outbound traffic for test ec2 instance"
  vpc_id      = module.connected_vpcs[each.value].vpc_attributes.id

  tags = merge(
    {
      Name = "${var.project}-${each.value}-test-ec2-sg"
    },
    var.tags
  )
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "ingress_cdu_sg" {
  for_each = toset(local.vpc_names)

  description       = "Allow inbound traffic for ICMP"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"] #TODO super-net
  security_group_id = aws_security_group.test_sg[each.value].id
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "egress_ec2_sg" {
  for_each = toset(local.vpc_names)

  description       = "Allow egress to all from ec2"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test_sg[each.value].id
}

# This allows instance to be managed via SystemsManager
data "aws_iam_policy" "ssm_managed_instance_core_policy" {
  count = local.create_test_ec2 ? 1 : 0
  name  = "AmazonSSMManagedInstanceCore"
}

# This allows permissions to access S3
data "aws_iam_policy" "s3_full_access_policy" {
  count = local.create_test_ec2 ? 1 : 0
  name  = "AmazonS3FullAccess"
}

# This allows permissions to access ec2
data "aws_iam_policy" "ec2_ro_access_policy" {
  count = local.create_test_ec2 ? 1 : 0
  name  = "AmazonEC2ReadOnlyAccess"
}

data "aws_iam_policy_document" "ec2_assume_role" {
  count = local.create_test_ec2 ? 1 : 0
  statement {
    sid = "AllowAssumeRoleToEC2"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_role" {
  count              = local.create_test_ec2 ? 1 : 0
  name               = "CustomEC2SSMMangedRole-${var.project}"
  description        = "This role is assumed by the EC2 instance and allow access via SSM"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role[0].json
}

resource "aws_iam_instance_profile" "ec2_role" {
  count = local.create_test_ec2 ? 1 : 0
  name  = "CustomEC2SSMMangedRole-${var.project}"
  role  = aws_iam_role.ec2_role[0].name
}

resource "aws_iam_role_policy_attachment" "ec2_role" {
  for_each = local.create_test_ec2 ? toset([
    data.aws_iam_policy.ssm_managed_instance_core_policy[0].arn,
    data.aws_iam_policy.s3_full_access_policy[0].arn,
    data.aws_iam_policy.ec2_ro_access_policy[0].arn,
  ]) : toset([])

  role       = aws_iam_role.ec2_role[0].name
  policy_arn = each.value
}

data "aws_iam_instance_profile" "ec2_role" {
  count = local.create_test_ec2 ? 1 : 0
  name  = aws_iam_instance_profile.ec2_role[0].name
}

resource "local_file" "test_ec2" {
  count = local.generate_ec2_test_script ? 1 : 0

  filename = "./.temp/${var.ec2_test_script}"
  #content = join("\n", [for key, phz in local.service_code_phz : "TEST=$(dig +short ${phz.phz}); if ${local.service_code_subnet_test[key].vpce_test} ; then echo \"${key}: Pass\" ; else echo \"${key}: Fail\" ; fi"])
  content = "#!/bin/bash\n\n${join("\n", local.ec2_tests)}"
}
