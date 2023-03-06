#Prefix List for NSS
resource "aws_ec2_managed_prefix_list" "nss_pl" {
  name           = "${var.project}-${var.env_name}-nss-pl"
  address_family = "IPv4"
  max_entries    = 45 #can connect only 45 VPCs

  tags = merge(var.tags, {
    Name = "${var.project}-${var.env_name}-nss-pl"
  })
}

#Entry for NSS PL
resource "aws_ec2_managed_prefix_list_entry" "nss_pl_nss_vpc" {
  for_each = local.use_super_net_cidr_blocks ? toset(var.super_net_cidr_blocks) : toset([var.cidr_block])

  cidr           = each.value
  description    = local.use_super_net_cidr_blocks ? "Super Net CIDR Block" : "Network Shared Services VPC"
  prefix_list_id = aws_ec2_managed_prefix_list.nss_pl.id
}

#Prefix List for NW Segment
resource "aws_ec2_managed_prefix_list" "nw_segment_pl" {
  for_each = toset(local.supported_network_segments)

  name           = "${var.project}-${var.env_name}-${each.value}-nw-segment-pl"
  address_family = "IPv4"
  max_entries    = each.value == "ISOLATED" ? 10 : 45

  tags = merge(var.tags, {
    Name = "${var.project}-${var.env_name}-${each.value}-nw-segment-pl"
  })
}

#Entry for NW Segment PL
resource "aws_ec2_managed_prefix_list_entry" "nw_segment_pl_nss_vpc" {
  for_each = { for pl_entry in local.nw_segment_pl_entries : pl_entry.pl_entry_key => pl_entry }

  cidr           = each.value.cidr_block
  description    = local.use_super_net_cidr_blocks ? "Super Net CIDR Block" : "Network Shared Services VPC"
  prefix_list_id = aws_ec2_managed_prefix_list.nw_segment_pl[each.value.nw_segment].id
}

resource "aws_ram_resource_share" "pl" {
  name = "${var.project}-${var.env_name}-pl-share"

  allow_external_principals = false

  tags = merge(
    {
      Name = "${var.project}-${var.env_name}-pl-share"
    },
    var.tags
  )
}

# Requires RAM enabled to share with AWS org
# Shared NSS PL
resource "aws_ram_resource_association" "nss_pl" {
  resource_arn       = aws_ec2_managed_prefix_list.nss_pl.arn
  resource_share_arn = aws_ram_resource_share.pl.arn
}

# Requires RAM enabled to share with AWS org
# Share NW Segment PLs
resource "aws_ram_resource_association" "nw_segment_pl" {
  for_each = toset(local.supported_network_segments)

  resource_arn       = aws_ec2_managed_prefix_list.nw_segment_pl[each.value].arn
  resource_share_arn = aws_ram_resource_share.pl.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "org" {
  count = var.share_with_org ? 1 : 0

  principal          = data.aws_organizations_organization.org.arn
  resource_share_arn = aws_ram_resource_share.pl.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "ou" {
  for_each = var.share_with_org ? toset([]) : toset(var.share_with_ous)

  principal          = "arn:aws:organizations::${local.master_account_id}:ou/${local.org_id}/${each.value}"
  resource_share_arn = aws_ram_resource_share.pl.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "account" {
  for_each = var.share_with_org ? toset([]) : toset(var.share_with_accounts)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.pl.arn
}
