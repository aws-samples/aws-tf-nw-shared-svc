locals {
  az_to_subnet = try(length(var.az_to_subnets), 0) != 0 ? var.az_to_subnets : {
    for subnet in data.aws_subnet.subnet : subnet.availability_zone => {
      id         = subnet.id
      cidr_block = subnet.cidr_block
      az_id      = subnet.availability_zone_id
  } }
  service_code_subnets = { for service_code, vpce_service in data.aws_vpc_endpoint_service.vpce_service : service_code => {
    subnet_ids = [for az, subnet in local.az_to_subnet : subnet.id if contains(vpce_service.availability_zones, az)]
    cidr_block = [for az, subnet in local.az_to_subnet : subnet.cidr_block if contains(vpce_service.availability_zones, az)]
    availability_zone = {
      for az, subnet in local.az_to_subnet : az => {
        az_id      = subnet.az_id
        subnet_id  = subnet.id
        cidr_block = subnet.cidr_block
      } if contains(vpce_service.availability_zones, az)
    }
    }
  }
  service_code_phz = { for service_code, vpce_service in data.aws_vpc_endpoint_service.vpce_service : service_code => {
    phz = try(length(vpce_service.private_dns_name), 0) == 0 ? local.aws_services[service_code].phz_name : substr(
      try(vpce_service.private_dns_name, "NONE"), 0, 1) == "*" ? substr(
    vpce_service.private_dns_name, 2, -1) : try(vpce_service.private_dns_name, "NONE")
    a_record = try(length(vpce_service.private_dns_name), 0) == 0 ? (
      try(length(local.aws_services[service_code].a_record), 0) == 0 ? "" : local.aws_services[service_code].a_record) : substr(
    try(vpce_service.private_dns_name, "NONE"), 0, 1) == "*" ? "*" : ""
    }
  }
}

locals {
  service_code_apex_alias = { for service_code, vpce in aws_vpc_endpoint.shared_endpoint : service_code => {
    vpce_dns_name = length(vpce.dns_entry) == (length(local.service_code_subnets[service_code].subnet_ids) + 1
    ) ? vpce.dns_entry[0].dns_name : vpce.dns_entry[length(local.service_code_subnets[service_code].subnet_ids) + 1].dns_name
    hosted_zone_id = length(vpce.dns_entry) == (length(local.service_code_subnets[service_code].subnet_ids) + 1
    ) ? vpce.dns_entry[0].hosted_zone_id : vpce.dns_entry[length(local.service_code_subnets[service_code].subnet_ids) + 1].hosted_zone_id
    network_interface_ids = [for eni in vpce.network_interface_ids : eni]
    }
  }
}

locals {
  service_code_subnet_test = { for service_code, subnet in local.service_code_subnets : service_code => {
    vpce_test = join(" || ",
      [
        for cb in local.service_code_subnets[service_code].cidr_block :
        "[[ \"$TEST\" == *\"${join(".", slice(split(".", cb), 0, 3))}\"* ]]"
      ]
    )
    }
  }
  vpce_tests = [
    for key, phz in local.service_code_phz :
    "TEST=$(dig +short ${phz.phz}); if ${local.service_code_subnet_test[key].vpce_test} ; then echo \"${key}: Pass\" ; else echo \"${key}: Fail\" ; fi"
  ]
}
