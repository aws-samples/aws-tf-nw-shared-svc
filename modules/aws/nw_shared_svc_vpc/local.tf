#const tags
locals {
  const_vpc_tags = {
    "shared.services" = "1"
  }
  const_public_subnet_tags = {
    "shared.services.public" = "1"
  }
  const_tgw_subnet_tags = {
    "shared.services.tgw" = "1"
  }
  const_vpce_subnet_tags = {
    "shared.services.vpce" = "1"
  }
  const_dnse_subnet_tags = {
    "shared.services.dnse" = "1"
  }
}

#VPC
locals {
  use_super_net_cidr_blocks = try(length(var.super_net_cidr_blocks), 0) != 0 ? true : false

  supported_network_segments = try(length(var.supported_network_segments), 0) == 0 ? ["ALL", "ISOLATED"] : distinct(flatten(
    ["ALL", "ISOLATED",
    var.supported_network_segments]
  ))

  nw_segment_pl_entries = flatten([
    for nw_segment in local.supported_network_segments : [
      for cidr_block in local.use_super_net_cidr_blocks ? toset(var.super_net_cidr_blocks) : toset([var.cidr_block]) : {
        pl_entry_key = "${nw_segment}-${cidr_block}"
        nw_segment   = nw_segment
        cidr_block   = cidr_block
      }
    ]
  ])

  vpc_netmask = tonumber(split("/", var.cidr_block)[1]) #16-20

  az_index         = var.az_count
  subnet_increment = 21 - local.vpc_netmask
  subnet_cidr_blocks = cidrsubnets(var.cidr_block,
    local.subnet_increment, local.subnet_increment,
    local.subnet_increment, local.subnet_increment,
    local.subnet_increment, local.subnet_increment,
    local.subnet_increment, local.subnet_increment
  )
  public_nm_increment = 24 - 21
  tgw_nm_increment    = 28 - 21
  vpce_nm_increment   = 24 - 21
  dnse_nm_increment   = 28 - 21

  public_calc_cidrs = [for index in range(var.az_count) : cidrsubnet(local.subnet_cidr_blocks[0], local.public_nm_increment, index)]
  tgw_calc_cidrs    = [for index in range(var.az_count) : cidrsubnet(local.subnet_cidr_blocks[1], local.tgw_nm_increment, index)]
  vpce_calc_cidrs   = [for index in range(var.az_count) : cidrsubnet(local.subnet_cidr_blocks[2], local.vpce_nm_increment, index)]
  dnse_calc_cidrs   = [for index in range(var.az_count) : cidrsubnet(local.subnet_cidr_blocks[3], local.dnse_nm_increment, index)]

  vpc_tags = merge(
    local.const_vpc_tags,
    var.vpc_tags
  )
}

#mandatory subnets
locals {
  public_cidrs = try(length(var.public_cidrs), 0) != 0 ? slice(var.public_cidrs, 0, local.az_index) : local.public_calc_cidrs

  public_subnet_tags = merge(
    local.const_public_subnet_tags,
    var.public_subnet_tags
  )

  tgw_cidrs = try(length(var.tgw_cidrs), 0) != 0 ? slice(var.tgw_cidrs, 0, local.az_index) : local.tgw_calc_cidrs

  tgw_subnet_tags = merge(
    local.const_tgw_subnet_tags,
    var.tgw_subnet_tags
  )
}

#Sharing
locals {
  org_id            = data.aws_organizations_organization.org.id
  master_account_id = data.aws_organizations_organization.org.master_account_id
}

#VPCE
locals {
  enable_vpce = var.enable_vpce

  vpce_cidrs = local.enable_vpce ? (
  try(length(var.vpce_cidrs), 0) != 0 ? slice(var.vpce_cidrs, 0, local.az_index) : local.vpce_calc_cidrs) : []

  vpce_subnet_tags = merge(
    local.const_vpce_subnet_tags,
    var.vpce_subnet_tags
  )

  vpce_subnet = local.enable_vpce ? {
    name_prefix             = "vpce"
    cidrs                   = local.vpce_cidrs
    connect_to_public_natgw = true
    tags                    = local.vpce_subnet_tags
  } : null
}

#DNSE
locals {
  enable_dnse = var.enable_dnse

  dnse_cidrs = local.enable_dnse ? (
  try(length(var.dnse_cidrs), 0) != 0 ? slice(var.dnse_cidrs, 0, local.az_index) : local.dnse_calc_cidrs) : []

  dnse_subnet_tags = merge(
    local.const_dnse_subnet_tags,
    var.dnse_subnet_tags
  )

  dnse_subnet = local.enable_dnse ? {
    name_prefix             = "dnse"
    cidrs                   = local.dnse_cidrs
    connect_to_public_natgw = true
    tags                    = local.dnse_subnet_tags
  } : null
}
