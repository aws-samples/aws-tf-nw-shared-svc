locals {
  tgw_tags = var.tgw_tags
}

#org
locals {
  org_id            = data.aws_organizations_organization.org.id
  master_account_id = data.aws_organizations_organization.org.master_account_id
}
