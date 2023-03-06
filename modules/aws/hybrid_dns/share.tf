resource "aws_ram_resource_share" "dnse_out" {
  name = "${var.project}-${var.env_name}-forward-rule-share"

  allow_external_principals = false

  tags = merge(
    {
      Name = "${var.project}-${var.env_name}-forward-rule-share"
    },
    var.tags,
    var.dnse_tags
  )
}

# Requires RAM enabled to share with AWS org
resource "aws_ram_resource_association" "dnse_out" {
  for_each = { for config in var.outbound_dns_resolver_config : config.domain_name => config }

  resource_arn       = aws_route53_resolver_rule.dnse_out[each.key].arn
  resource_share_arn = aws_ram_resource_share.dnse_out.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "org" {
  count = var.share_with_org ? 1 : 0

  principal          = data.aws_organizations_organization.org.arn
  resource_share_arn = aws_ram_resource_share.dnse_out.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "ou" {
  for_each = var.share_with_org ? toset([]) : toset(var.share_with_ous)

  principal          = "arn:aws:organizations::${local.master_account_id}:ou/${local.org_id}/${each.value}"
  resource_share_arn = aws_ram_resource_share.dnse_out.arn
}

# Requires RAM enabled to share with AWS org:
# enable in org master account with 'aws ram enable-sharing-with-aws-organization'
resource "aws_ram_principal_association" "account" {
  for_each = var.share_with_org ? toset([]) : toset(var.share_with_accounts)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.dnse_out.arn
}
