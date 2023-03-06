resource "aws_vpc_endpoint" "shared_endpoint" {
  for_each   = toset(var.vpce_service_codes)
  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = local.service_code_subnets[each.value].subnet_ids

  service_name      = data.aws_vpc_endpoint_service.vpce_service[each.value].service_name
  vpc_endpoint_type = data.aws_vpc_endpoint_service.vpce_service[each.value].service_type

  security_group_ids = [data.aws_security_group.vpce_sg.id]

  private_dns_enabled = false  #TODO should it be false only for Interface
  ip_address_type     = "ipv4" # TODO, enable_dual_stack ipv4, dualstack, ipv6

  tags = merge(
    {
      Name = each.value
    },
    var.subnet_tags,
    var.tags
  )
}

resource "aws_route53_zone" "vpce_phz" {
  for_each = toset(var.vpce_service_codes)

  name    = local.service_code_phz[each.value].phz
  comment = "Private hosted zone for network shared service - vpce - ${each.value}"

  #one or more VPCs, assign shared services VPC here, consumers will be associated outside of this
  vpc {
    vpc_id = data.aws_vpc.vpc.id
  }

  force_destroy = true

  tags = merge(
    {
      #Name                  = local.service_code_phz[each.value].phz
      "shared.service.vpce" = each.value
    },
    var.subnet_tags,
    var.tags
  )

  #Prevent the deletion of associated VPCs after the initial creation
  lifecycle {
    ignore_changes = [
      vpc
    ]
  }
}

# apex record for the private hosted zone.
resource "aws_route53_record" "vpce_phz" {
  # checkov:skip=CKV2_AWS_23: A Record is from Alias
  for_each = { for service_code, apex_alias in local.service_code_apex_alias : service_code => apex_alias }

  zone_id = aws_route53_zone.vpce_phz[each.key].zone_id
  name    = local.service_code_phz[each.key].phz
  type    = "A"

  alias {
    name                   = replace(each.value.vpce_dns_name, "*", "\\052")
    zone_id                = each.value.hosted_zone_id
    evaluate_target_health = true
  }
}

#A record for private_dns_names starting with *
#TODO verify local.aws_services.a_record is correct for all supported service codes
resource "aws_route53_record" "vpce_phz_wildcard" {
  # checkov:skip=CKV2_AWS_23: A Record is from Alias
  for_each = toset([for service_code in var.vpce_service_codes : service_code
    if try(length(local.aws_services[service_code].a_record), 0) != 0
  ])

  zone_id = aws_route53_zone.vpce_phz[each.value].zone_id
  name    = local.service_code_phz[each.value].a_record
  type    = "A"

  alias {
    name                   = replace(local.service_code_apex_alias[each.value].vpce_dns_name, "*", "\\052")
    zone_id                = local.service_code_apex_alias[each.value].hosted_zone_id
    evaluate_target_health = true
  }
}

# resource "aws_vpc_endpoint_policy" "example" {
#   vpc_endpoint_id = aws_vpc_endpoint.example.id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "AllowAll",
#         "Effect" : "Allow",
#         "Principal" : {
#           "AWS" : "*"
#         },
#         "Action" : [
#           "dynamodb:*"
#         ],
#         "Resource" : "*"
#       }
#     ]
#   })
# }

resource "local_file" "test_vpce" {
  count = var.generate_vpce_test_script ? 1 : 0

  filename = "./.temp/test_vpce.sh"
  #content = join("\n", [for key, phz in local.service_code_phz : "TEST=$(dig +short ${phz.phz}); if ${local.service_code_subnet_test[key].vpce_test} ; then echo \"${key}: Pass\" ; else echo \"${key}: Fail\" ; fi"])
  content = "#!/bin/bash\n\n${join("\n", local.vpce_tests)}"
}

# resource "local_file" "list_vpce" {
#   filename = "${path.module}/services.md"
#   content = join("\n", [
#     "# Supported Services",
#     "",
#     "| Service Code | AWS Service Name | Service Name | Endpoint |",
#     "|--------------|------------------|--------------|----------|",
#     join("\n", [for k, v in local.aws_services : "| ${k} | ${v.service_name} | ${replace(v.name, "us-east-1", "<span style='color:red'>*region*</span>")} | ${replace(v.phz_name, "us-east-1", "<span style='color:red'>*region*</span>")} |"])
#     ]
#   )
# }
