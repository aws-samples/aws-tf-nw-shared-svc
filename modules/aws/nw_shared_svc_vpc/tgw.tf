#TODO allow using existing TGW, accept tgw_id as input and optionally create this tgw
module "shared_tgw" {
  source = "../transit_gw"

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  #tgw
  amazon_side_asn = var.amazon_side_asn
  tgw_tags        = var.tgw_tags

  #Sharing
  share_with_org      = var.share_with_org
  share_with_ous      = var.share_with_ous
  share_with_accounts = var.share_with_accounts
}

resource "aws_ec2_transit_gateway_route_table" "nss_vpc_tgw_rt" {
  transit_gateway_id = module.shared_tgw.tgw_id

  tags = merge(var.tags, {
    Name = "${var.project}-${var.env_name}-nss-vpc-tgw-rt"
  })
}

resource "aws_ec2_transit_gateway_route_table_association" "nss_vpc_tgw_rt" {
  transit_gateway_attachment_id  = module.shared_services_vpc.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.nss_vpc_tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table" "nw_segment_tgw_rt" {
  for_each = toset(local.supported_network_segments)

  transit_gateway_id = module.shared_tgw.tgw_id

  tags = merge(var.tags, {
    Name = "${var.project}-${var.env_name}-${each.value}-nw-segment-tgw-rt"
  })
}

#TODO static route 0.0.0.0/0, if centralized egress enabled
# nss propagate to the network segment TGW Route Table
resource "aws_ec2_transit_gateway_route_table_propagation" "nss_propagation_to_nw_segment_tgw_rt" {
  for_each = toset(local.supported_network_segments)

  transit_gateway_attachment_id  = module.shared_services_vpc.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.nw_segment_tgw_rt[each.value].id
}
