#VPC
locals {
  use_super_net_cidr_blocks = try(length(var.super_net_cidr_blocks), 0) != 0 ? true : false
  supported_network_segments = try(length(var.supported_network_segments), 0) == 0 ? ["ALL", "ISOLATED"] : distinct(flatten(
    ["ALL", "ISOLATED",
    var.supported_network_segments]
  ))

  #pl entries for on-premises cidrs, apply only if super-net is not used
  nw_segment_pl_entries = flatten([
    for nw_segment in local.supported_network_segments : [
      for cidr_block in var.on_premises_cidrs : {
        pl_entry_key = "${nw_segment}-${cidr_block}"
        nw_segment   = nw_segment
        cidr_block   = cidr_block
      }
    ]
  ])
}

#VPCE
locals {
  enable_vpce = try(length(var.vpce_service_codes), 0) != 0 ? true : false
}

#DNSE
locals {
  enable_dnse = try(length(var.on_premises_cidrs), 0) != 0 || try(length(var.outbound_dns_resolver_config), 0) != 0
}
