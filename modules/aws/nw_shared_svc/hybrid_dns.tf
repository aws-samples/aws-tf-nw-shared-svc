module "hybrid_dns" {
  source = "../hybrid_dns"
  count  = local.enable_dnse ? 1 : 0

  project  = var.project
  env_name = var.env_name
  tags     = var.tags

  #Network
  #vpc_tags     = local.const_vpc_tags
  #subnet_tags = local.const_vpce_subnet_tags
  vpc_id = module.shared_services_vpc.vpc_id
  subnets = [for key, subnet in module.shared_services_vpc.private_subnet_attributes_by_az :
    {
      subnet_id  = subnet.id
      cidr_block = subnet.cidr_block
    } if split("/", key)[0] == "dnse"
  ]
  dnse_tags = var.dnse_tags

  on_premises_cidrs            = var.on_premises_cidrs
  outbound_dns_resolver_config = var.outbound_dns_resolver_config

  #TODO for future use
  #enable_dns_query_log = var.enable_dns_query_log
  #TODO for future use
  #enable_dns_qps_alarm = var.enable_dns_qps_alarm

  #Sharing
  share_with_org      = var.share_with_org
  share_with_ous      = var.share_with_ous
  share_with_accounts = var.share_with_accounts
}
