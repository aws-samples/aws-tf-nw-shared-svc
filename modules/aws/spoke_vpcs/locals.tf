#NSS specs
locals {
  use_super_net_cidr_blocks = try(length(var.nw_shared_svc_attributes.super_net_cidr_blocks), 0) != 0 ? true : false

  supported_network_segments     = var.nw_shared_svc_attributes.supported_network_segments
  nw_shared_svc_prefix_list_id   = var.nw_shared_svc_attributes.nw_shared_svc_prefix_list_id
  nw_segment_prefix_list_ids     = var.nw_shared_svc_attributes.nw_segment_prefix_list_ids
  tgw_id                         = var.nw_shared_svc_attributes.nw_shared_svc_tgw_id
  nss_tgw_route_table_id         = var.nw_shared_svc_attributes.nw_shared_svc_tgw_route_table_id
  nw_segment_tgw_route_table_ids = var.nw_shared_svc_attributes.nw_segment_tgw_route_table_ids
}

#vpc_specs defaults
locals {
  spoke_vpc_specs = [for vpc_specs in var.spoke_vpc_specs :
    {
      vpc_name_prefix                          = "${vpc_specs.name_prefix}-${vpc_specs.env_name}"
      name_prefix                              = vpc_specs.name_prefix
      env_name                                 = vpc_specs.env_name
      cidr_block                               = vpc_specs.cidr_block
      az_count                                 = vpc_specs.az_count
      tags                                     = try(length(vpc_specs.tags), 0) != 0 ? vpc_specs.tags : {}
      network_segment                          = try(length(vpc_specs.network_segment), 0) != 0 ? contains(local.supported_network_segments, vpc_specs.network_segment) ? vpc_specs.network_segment : "ISOLATED" : "ISOLATED"
      enable_centralized_vpc_endpoints         = try(vpc_specs.enable_centralized_vpc_endpoints == true, false)
      vpce_service_codes                       = try(length(vpc_specs.vpce_service_codes), 0) != 0 ? vpc_specs.vpce_service_codes : []
      enable_hybrid_dns                        = try(vpc_specs.enable_hybrid_dns == true, false)
      enable_centralized_egress_to_internet    = try(vpc_specs.enable_centralized_egress_to_internet == true, false)
      enable_centralized_ingress_from_internet = try(vpc_specs.enable_centralized_ingress_from_internet == true, false)
      create_test_ec2                          = try(vpc_specs.create_test_ec2 == true, false)
      subnets = [for subnet in vpc_specs.subnets :
        {
          name_prefix = subnet.name_prefix
          cidrs       = subnet.cidrs
          type        = contains(["public", "private", "transit_gateway"], subnet.type) ? subnet.type : "private"
          tags        = try(length(subnet.tags), 0) != 0 ? subnet.tags : {}
        }
      ]
    }
  ]

  spoke_vpc_pl = [for vpc_specs in local.spoke_vpc_specs :
    {
      vpc_name_prefix    = "${vpc_specs.name_prefix}-${vpc_specs.env_name}"
      cidr_block         = vpc_specs.cidr_block
      network_segment    = vpc_specs.network_segment
      network_segment_pl = local.nw_segment_prefix_list_ids[vpc_specs.network_segment]
    }
  ]
}

#vpce
locals {
  vpce_specs = var.nw_shared_svc_attributes.vpce_specs

  vpc_vpce_phz_assoc = flatten([
    for vpc_specs in local.spoke_vpc_specs : [
      for service_code, vpce_spec in local.vpce_specs : {
        vpc_name_prefix = "${vpc_specs.name_prefix}-${vpc_specs.env_name}"
        service_code    = service_code
        vpc_id          = module.connected_vpcs["${vpc_specs.name_prefix}-${vpc_specs.env_name}"].vpc_attributes.id
        zone_id         = vpce_spec.hosted_zone_id
      } if try(length(vpc_specs.vpce_service_codes), 0) == 0 || contains(vpc_specs.vpce_service_codes, service_code)
    ] if vpc_specs.enable_centralized_vpc_endpoints
  ])
}

#dnse
locals {
  dns_resolver_rules = var.nw_shared_svc_attributes.hybrid_dns_specs.dns_resolver_rules

  vpc_dns_resolver_rule_assoc = flatten([
    for vpc_specs in local.spoke_vpc_specs : [
      for rule in local.dns_resolver_rules : {
        vpc_name_prefix = "${vpc_specs.name_prefix}-${vpc_specs.env_name}"
        domain_name     = rule.domain_name
        vpc_id          = module.connected_vpcs["${vpc_specs.name_prefix}-${vpc_specs.env_name}"].vpc_attributes.id
        rule_id         = rule.id
      }
    ] if vpc_specs.enable_hybrid_dns
  ])
}
