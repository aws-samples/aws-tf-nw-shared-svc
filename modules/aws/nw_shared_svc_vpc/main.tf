module "shared_services_vpc" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.0.0"

  name       = "${var.project}-${var.env_name}"
  cidr_block = var.cidr_block
  az_count   = var.az_count

  subnets = { for k, v in merge(
    #mandatory
    {
      public = {
        name_prefix               = "public" # omit to prefix with "public"
        cidrs                     = local.public_cidrs
        nat_gateway_configuration = var.nat_gateway_config
        tags                      = local.public_subnet_tags
      },
      transit_gateway = {
        name_prefix             = "tgw"
        cidrs                   = local.tgw_cidrs
        connect_to_public_natgw = true

        transit_gateway_default_route_table_association = false
        transit_gateway_default_route_table_propagation = false
        transit_gateway_appliance_mode_support          = "disable"
        transit_gateway_dns_support                     = "enable"

        tags = local.tgw_subnet_tags
      },
    },
    {
      vpce = local.vpce_subnet
    },
    {
      dnse = local.dnse_subnet
    }
  ) : k => v if v != null }

  transit_gateway_id = module.shared_tgw.tgw_id
  transit_gateway_routes = {
    public = aws_ec2_managed_prefix_list.nss_pl.id
    vpce   = aws_ec2_managed_prefix_list.nss_pl.id
    dnse   = aws_ec2_managed_prefix_list.nss_pl.id
  }

  # Re-enumerating defaults for completeness
  vpc_enable_dns_hostnames = true
  vpc_enable_dns_support   = true

  # Not using IPAM, re-enumerating defaults
  vpc_ipv4_ipam_pool_id   = null
  vpc_ipv4_netmask_length = null

  tags = merge(var.tags, local.vpc_tags)
}
