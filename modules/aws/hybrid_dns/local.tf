locals {
  enable_inbound_dnse = try(length(var.on_premises_cidrs), 0) != 0

  enable_outbound_dnse = try(length(var.outbound_dns_resolver_config), 0) != 0
  outbound_dns_ips     = distinct(flatten([for config in var.outbound_dns_resolver_config : config.target_ip_addresses]))

  vpc_id = data.aws_vpc.vpc.id
  subnets = try(length(var.subnets), 0) != 0 ? var.subnets : [
    for subnet in data.aws_subnet.subnet : {
      subnet_id  = subnet.id
      cidr_block = subnet.cidr_block
  }]
}

#Sharing
locals {
  org_id            = data.aws_organizations_organization.org.id
  master_account_id = data.aws_organizations_organization.org.master_account_id
}
