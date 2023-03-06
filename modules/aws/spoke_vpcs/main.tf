module "connected_vpcs" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.0.0"

  for_each = { for vpc_specs in local.spoke_vpc_specs : "${vpc_specs.name_prefix}-${vpc_specs.env_name}" => vpc_specs }

  name       = "${var.project}-${each.key}"
  cidr_block = each.value.cidr_block
  az_count   = each.value.az_count

  subnets = merge(
    #private with egress
    { for subnet in each.value.subnets : subnet.name_prefix =>
      {
        name_prefix             = "${each.key}-${subnet.name_prefix}"
        cidrs                   = subnet.cidrs
        tags                    = subnet.tags
        connect_to_public_natgw = each.value.enable_centralized_egress_to_internet ? false : true
      } if try(length(subnet.type), 0) == 0 || subnet.type == "private"
    },
    #public with ingress
    { for subnet in each.value.subnets : "public" =>
      {
        name_prefix = "${each.key}-${subnet.name_prefix}"
        cidrs       = subnet.cidrs
        tags        = subnet.tags
        #TODO "single_az" or "all_azs" as default.
        nat_gateway_configuration = each.value.enable_centralized_egress_to_internet ? "none" : "single_az"
      } if try(length(subnet.type), 0) != 0 && subnet.type == "public"
    },
    { for subnet in each.value.subnets : "transit_gateway" =>
      {
        name_prefix = "${each.key}-tgw"
        cidrs       = subnet.cidrs
        #tgw does not connect to NATGW for spoke vpc
        connect_to_public_natgw = false

        transit_gateway_default_route_table_association = false
        transit_gateway_default_route_table_propagation = false
        transit_gateway_appliance_mode_support          = "disable"
        transit_gateway_dns_support                     = "enable"

        tags = subnet.tags
      } if try(length(subnet.type), 0) != 0 && subnet.type == "transit_gateway"
    }
  )

  transit_gateway_id = local.tgw_id
  transit_gateway_routes = {
    for subnet in each.value.subnets : subnet.name_prefix =>
    local.nw_segment_prefix_list_ids[each.value.network_segment] if try(length(subnet.type), 0) == 0 || subnet.type == "private" || subnet.type == "public"
  }

  # Re-enumerating defaults for completeness
  vpc_enable_dns_hostnames = true
  vpc_enable_dns_support   = true

  # Not using IPAM, re-enumerating defaults
  vpc_ipv4_ipam_pool_id   = null
  vpc_ipv4_netmask_length = null

  tags = merge(var.tags, each.value.tags)
}
