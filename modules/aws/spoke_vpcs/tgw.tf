# For nw segment connected VPCs add entry in nw_segment_pl, only if not using super net
resource "aws_ec2_managed_prefix_list_entry" "nw_segment_pl_spoke_vpc" {
  for_each = local.use_super_net_cidr_blocks ? {} : { for pl_entry in local.spoke_vpc_pl : pl_entry.vpc_name_prefix =>
    pl_entry if pl_entry.network_segment != "ISOLATED"
  }
  provider = aws.hub

  cidr           = each.value.cidr_block
  description    = "Connected VPC ${each.key}"
  prefix_list_id = each.value.network_segment_pl
}

# For all VPCs add entry in nss_pl, only if not using super net
resource "aws_ec2_managed_prefix_list_entry" "nss_pl_spoke_vpc" {
  for_each = local.use_super_net_cidr_blocks ? {} : { for pl_entry in local.spoke_vpc_pl : pl_entry.vpc_name_prefix => pl_entry }
  provider = aws.hub

  cidr           = each.value.cidr_block
  description    = "Connected VPC ${each.key}"
  prefix_list_id = local.nw_shared_svc_prefix_list_id
}

# Associate spoke vpc tgw attachment with network segment tgw route table
resource "aws_ec2_transit_gateway_route_table_association" "vpc_tgw_rt" {
  for_each = { for vpc_specs in local.spoke_vpc_specs : "${vpc_specs.name_prefix}-${vpc_specs.env_name}" => vpc_specs }
  provider = aws.hub

  transit_gateway_attachment_id  = module.connected_vpcs[each.key].transit_gateway_attachment_id
  transit_gateway_route_table_id = local.nw_segment_tgw_route_table_ids[each.value.network_segment]
}

# All the Spoke VPCs propagate to the NSS TGW Route Table
resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_propagation_to_nss_tgw_rt" {
  for_each = { for vpc_specs in local.spoke_vpc_specs : "${vpc_specs.name_prefix}-${vpc_specs.env_name}" => vpc_specs }
  provider = aws.hub

  transit_gateway_attachment_id  = module.connected_vpcs[each.key].transit_gateway_attachment_id
  transit_gateway_route_table_id = local.nss_tgw_route_table_id
}

# All the Spoke VPCs propagate to the network segment TGW Route Table, if nw segment is not "ISOLATED"
resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_propagation_to_nw_segment_tgw_rt" {
  for_each = { for vpc_specs in local.spoke_vpc_specs : "${vpc_specs.name_prefix}-${vpc_specs.env_name}" =>
    vpc_specs if vpc_specs.network_segment != "ISOLATED" #|| vpc_specs.network_segment != "ALL"
  }
  provider = aws.hub

  transit_gateway_attachment_id  = module.connected_vpcs[each.key].transit_gateway_attachment_id
  transit_gateway_route_table_id = local.nw_segment_tgw_route_table_ids[each.value.network_segment]
}

# # All the Spoke VPCs propagate to the ALL network segment TGW Route Table
# resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_propagation_to_all_tgw_rt" {
#   for_each = { for vpc_specs in local.spoke_vpc_specs : "${vpc_specs.name_prefix}-${vpc_specs.env_name}" =>
#     vpc_specs
#   }
#   provider = aws.hub

#   transit_gateway_attachment_id  = module.connected_vpcs[each.key].transit_gateway_attachment_id
#   transit_gateway_route_table_id = local.nw_segment_tgw_route_table_ids["ALL"]
# }
