module "shared_services_vpc" {
  source = "../nw_shared_svc_vpc"

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  #VPC
  super_net_cidr_blocks      = var.super_net_cidr_blocks
  cidr_block                 = var.cidr_block
  az_count                   = var.az_count
  vpc_tags                   = var.vpc_tags
  supported_network_segments = var.supported_network_segments

  #public subnet
  public_cidrs       = var.public_cidrs
  nat_gateway_config = var.nat_gateway_config
  public_subnet_tags = var.public_subnet_tags

  #tgw
  amazon_side_asn = var.amazon_side_asn
  tgw_tags        = var.tgw_tags
  tgw_cidrs       = var.tgw_cidrs
  tgw_subnet_tags = var.tgw_subnet_tags

  #Sharing
  share_with_org      = var.share_with_org
  share_with_ous      = var.share_with_ous
  share_with_accounts = var.share_with_accounts

  #VPCE
  enable_vpce      = local.enable_vpce
  vpce_cidrs       = var.vpce_cidrs
  vpce_subnet_tags = var.vpce_subnet_tags

  #DNSE
  enable_dnse      = local.enable_dnse
  dnse_cidrs       = var.dnse_cidrs
  dnse_subnet_tags = var.dnse_subnet_tags
}

resource "aws_ec2_managed_prefix_list_entry" "nss_pl_on_prem" {
  for_each = local.use_super_net_cidr_blocks ? toset([]) : toset(var.on_premises_cidrs)

  cidr           = each.value
  description    = "On-Premises CIDR ${each.value}"
  prefix_list_id = module.shared_services_vpc.nw_shared_svc_prefix_list_id
}

resource "aws_ec2_managed_prefix_list_entry" "nw_segment_pl_on_prem" {
  for_each = { for pl_entry in local.use_super_net_cidr_blocks ? [] : local.nw_segment_pl_entries : pl_entry.pl_entry_key => pl_entry }

  cidr           = each.value.cidr_block
  description    = "On-Premises CIDR ${each.value.cidr_block}"
  prefix_list_id = module.shared_services_vpc.nw_segment_prefix_list_ids[each.value.nw_segment]
}
