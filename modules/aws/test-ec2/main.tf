data "aws_region" "current" {}
data "aws_availability_zones" "current" {}

locals {
  region = data.aws_region.current.name

  create_test_ec2 = length([for entry in var.vpcs : entry.vpc_name if entry.create_test_ec2]) != 0 ? true : false
  vpc_specs       = { for entry in var.vpcs : entry.vpc_name => entry if entry.create_test_ec2 }

  # flatten for subnets
  vpc_subnet_ec2 = flatten([
    for vpc_spec in local.vpc_specs : [
      for subnet_id in vpc_spec.subnet_ids : {
        vpc_name  = vpc_spec.vpc_name
        subnet_id = subnet_id
        tags      = vpc_spec.tags
      }
    ]
  ])
}

locals {
  generate_ec2_test_script = true

  ec2_tests = flatten([
    for vpc_spec in local.vpc_specs : [
      "echo \"-------------------------------------------\"",
      "echo \"VPC Name: ${vpc_spec.vpc_name}\"",
      "echo \"VpcRole: ${vpc_spec.vpc_role}\"",
      "echo \"VpcId: ${vpc_spec.vpc_id}\"",
      [
        for subnet_id in vpc_spec.subnet_ids : [
          "TEST=$(ping -c 1 -W 5 ${aws_instance.private["${vpc_spec.vpc_name}-${subnet_id}"].private_ip});if [[ \"$TEST\" == *\"1 received\"* ]];then echo \"${aws_instance.private["${vpc_spec.vpc_name}-${subnet_id}"].private_dns}: Reachable\"; else echo \"${aws_instance.private["${vpc_spec.vpc_name}-${subnet_id}"].private_dns}: Not-Reachable\"; fi",
          "TEST=$(ping -c 1 -W 5 ${aws_instance.private["${vpc_spec.vpc_name}-${subnet_id}"].private_ip});if [[ \"$TEST\" == *\"1 received\"* ]];then echo \"${aws_instance.private["${vpc_spec.vpc_name}-${subnet_id}"].private_ip}: Reachable\"; else echo \"${aws_instance.private["${vpc_spec.vpc_name}-${subnet_id}"].private_ip}: Not-Reachable\"; fi"
      ]]
    ]
  ])

  vpce_test = join(" || ",
    [
      for cb in var.vpce_cidrs :
      "[[ \"$TEST\" == *\"${join(".", slice(split(".", cb), 0, 3))}\"* ]]"
    ]
  )

  aws_svc_tests = [for svc in var.vpce_services :
    "SVC=${svc}.${local.region}.amazonaws.com; TEST=$(dig +short $SVC); if ${local.vpce_test} ; then echo $SVC: Pass ; else echo $SVC: Fail; fi"
  ]
}

resource "aws_instance" "private" {
  # checkov:skip=CKV_AWS_8: test instances, no need to encrypt EBS
  # checkov:skip=CKV_AWS_135: test instances, no need to optimize EBS
  # checkov:skip=CKV_AWS_126: test instances, no need for detailed monitoring
  for_each = { for subnet in local.vpc_subnet_ec2 : "${subnet.vpc_name}-${subnet.subnet_id}" => subnet }

  ami                         = data.aws_ami.test_ami[0].id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  iam_instance_profile        = data.aws_iam_instance_profile.ec2_role[0].name
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = [aws_security_group.test_sg[each.value.vpc_name].id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = merge(each.value.tags,
    {
      Name    = "${each.key}-test-ec2",
      Purpose = "connectivity-test"
    }
  )
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
    values = var.instance_architecture #["x86_64"] #i386 | x86_64 | arm64 # TODO variable
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = var.instance_volume_type #["gp2"] #io1 | io2 | gp2 | gp3 | sc1 | st1 | standard
  }
}

resource "aws_security_group" "test_sg" {
  # checkov:skip=CKV2_AWS_5: SG is attached in the resource module
  # checkov:skip=CKV_AWS_23: N/A
  for_each = local.vpc_specs

  name        = "${each.key}-test-ec2-sg"
  description = "Secure inbound/outbound traffic for test ec2 instance"
  vpc_id      = each.value.vpc_id

  tags = {
    Name = "${each.key}-test-ec2-sg"
  }
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "ingress_test_sg" {
  for_each = local.vpc_specs

  description       = "Allow inbound traffic for ICMP"
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"] #TODO super-net
  security_group_id = aws_security_group.test_sg[each.key].id
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "egress_test_sg" {
  for_each = local.vpc_specs

  description       = "Allow egress to all from ec2"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test_sg[each.key].id
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
  name               = "CustomEC2SSMMangedRole-TestEC2"
  description        = "This role is assumed by the EC2 instance and allow access via SSM"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role[0].json
}

resource "aws_iam_instance_profile" "ec2_role" {
  count = local.create_test_ec2 ? 1 : 0
  name  = "CustomEC2SSMMangedRole-TestEC2"
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

resource "local_file" "test_ec2_json" {
  count = local.generate_ec2_test_script ? 1 : 0

  # filename = "./.temp/test_connectivity.sh"
  # content = join("\n", [for key, phz in local.service_code_phz : "TEST=$(dig +short ${phz.phz}); if ${local.service_code_subnet_test[key].vpce_test} ; then echo \"${key}: Pass\" ; else echo \"${key}: Fail\" ; fi"])
  # content = "#!/bin/bash\n\n${join("\n", local.aws_svc_tests)}\n\n${join("\n", local.ec2_tests)}"
  filename        = "./resources/test-connectivity.json"
  file_permission = "0644"
  content = jsonencode({
    "Parameters" : {
      "commands" : flatten([
        "#!/bin/bash",
        "echo \"VPC Endpoint Testing:...\"",
        local.aws_svc_tests,
        "echo \"\"",
        "echo \"EC2 Connectivity Testing:...\"",
        local.ec2_tests
      ])
    }
  })
}

resource "local_file" "test_ec2_sh" {
  count = local.generate_ec2_test_script ? 1 : 0

  # filename = "./.temp/test_connectivity.sh"
  # content = join("\n", [for key, phz in local.service_code_phz : "TEST=$(dig +short ${phz.phz}); if ${local.service_code_subnet_test[key].vpce_test} ; then echo \"${key}: Pass\" ; else echo \"${key}: Fail\" ; fi"])
  # content = "#!/bin/bash\n\n${join("\n", local.aws_svc_tests)}\n\n${join("\n", local.ec2_tests)}"
  filename        = "./resources/test-connectivity.sh"
  file_permission = "0755"
  content         = "#!/bin/bash\n\necho \"VPC Endpoint Testing:...\"\n${join("\n", local.aws_svc_tests)}\n\necho \"\"\necho \"EC2 Connectivity Testing:...\"\n${join("\n", local.ec2_tests)}"
}

resource "local_file" "test_ec2_from_ec2" {
  filename        = "./resources/test-connectivity-from-ec2.sh"
  file_permission = "0755"
  source          = "${path.module}/resources/test-connectivity-from-ec2.sh"
}
