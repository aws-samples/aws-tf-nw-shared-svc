# output "test1" {
#     value = [for service_code, service_spec in local.aws_services : {
#         service_code = service_code
#         name_test1 = split(".", service_spec.name)[length(split(".", service_spec.name))-1] == split(".", service_spec.phz_name)[0]
#         name_test2 = split(".", service_spec.name)[length(split(".", service_spec.name))-2] == split(".", service_spec.phz_name)[1]
#     }]
# }

# output "test_nslookup" {
#     value = join("\n", [for service_code, service_spec in local.aws_services : "nslookup ${service_spec.phz_name}"])
# }

output "supported_service_codes" {
  description = "List of supported service codes for this module."
  value = { for service_code, service_spec in local.aws_services : service_code =>
    {
      service_name     = "com.amazonaws.${var.region}.translate"
      aws_service_name = "Amazon Translate"
      endpoint         = "translate.${var.region}.amazonaws.com"
    }
  }
}

output "vpce_specs" {
  description = "The detail about the created VPC Endpoints."
  value = { for key, vpce_service in data.aws_vpc_endpoint_service.vpce_service : key =>
    {
      phz            = local.service_code_phz[key].phz
      vpce_dns_name  = local.service_code_apex_alias[key].vpce_dns_name
      hosted_zone_id = aws_route53_zone.vpce_phz[key].zone_id
    }
  }
}
