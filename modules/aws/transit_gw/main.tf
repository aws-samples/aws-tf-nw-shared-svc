resource "aws_ec2_transit_gateway" "tgw" {
  description     = "Network Shared Services TGW with auto-accept enabled."
  amazon_side_asn = var.amazon_side_asn

  auto_accept_shared_attachments = "enable"
  vpn_ecmp_support               = "enable"
  dns_support                    = "enable"

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  multicast_support               = "disable" #TODO conditionally enabled in future

  #TODO future enhancement
  #transit_gateway_cidr_blocks = []

  tags = merge(
    {
      Name = "${var.project}-${var.env_name}-tgw"
    },
    var.tags,
    local.tgw_tags
  )
}

resource "aws_ram_resource_share" "tgw" {
  name = "${var.project}-${var.env_name}-tgw-share"

  allow_external_principals = false

  tags = merge(
    {
      Name = "${var.project}-${var.env_name}-tgw-share"
    },
    var.tags,
    local.tgw_tags
  )
}

# Requires RAM enabled to share with AWS org
resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.tgw.arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "org" {
  count              = var.share_with_org ? 1 : 0
  principal          = data.aws_organizations_organization.org.arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "ou" {
  for_each           = var.share_with_org ? toset([]) : toset(var.share_with_ous)
  principal          = "arn:aws:organizations::${local.master_account_id}:ou/${local.org_id}/${each.value}"
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "account" {
  for_each           = var.share_with_org ? toset([]) : toset(var.share_with_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.tgw.arn
}
