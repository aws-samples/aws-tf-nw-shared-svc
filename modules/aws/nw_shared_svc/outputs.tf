output "vpc_id" {
  description = "VPC Id for the provisioned VPC"
  value       = module.shared_services_vpc.vpc_id
}

output "vpc_attributes" {
  description = "VPC attributes for the provisioned VPC"
  value       = module.shared_services_vpc.vpc_attributes
}

output "azs" {
  description = "List of AZs where subnets are created."
  value       = module.shared_services_vpc.azs
}

output "private_subnet_attributes_by_az" {
  description = "List of private subnet attributes by AZ."
  value       = module.shared_services_vpc.private_subnet_attributes_by_az
}

output "nss_attributes" {
  description = <<-EOF
  Network Shared Services attributes, used by spoke_vpcs module.
  `super_net_cidr_blocks`, Super Net CIDR Blocks used for routing.
  `supported_network_segments`, List of supported network segments by NSS.
  `nw_shared_svc_prefix_list_id`, Prefix list id for NSS.
  `nw_segment_prefix_list_ids`, Prefix list id for network segment(s).
  `nw_shared_svc_tgw_id`, Transit GW Id that enables network shared services VPC.
  `nw_shared_svc_tgw_route_table_id`, TGW route table id for the network shared services VPC.
  `nw_segment_tgw_route_table_ids`, TGW route table id for network segment(s).
  `vpce_specs`, Map of shareable VPC endpoints by service codes.
  `hybrid_dns_specs.inbound_dns_resolver_endpoints`, Inbound DNS Resolver Endpoint(s) to be used to configure On-premises DNS server(s)
  `hybrid_dns_specs.dns_resolver_rules`, DNS resolver rules that are shared.
  EOF
  value = {
    super_net_cidr_blocks            = module.shared_services_vpc.super_net_cidr_blocks
    supported_network_segments       = module.shared_services_vpc.supported_network_segments
    nw_shared_svc_prefix_list_id     = module.shared_services_vpc.nw_shared_svc_prefix_list_id
    nw_segment_prefix_list_ids       = module.shared_services_vpc.nw_segment_prefix_list_ids
    nw_shared_svc_tgw_id             = module.shared_services_vpc.nw_shared_svc_tgw_id
    nw_shared_svc_tgw_route_table_id = module.shared_services_vpc.nw_shared_svc_tgw_route_table_id
    nw_segment_tgw_route_table_ids   = module.shared_services_vpc.nw_segment_tgw_route_table_ids
    vpce_specs                       = local.enable_vpce ? module.vpc_endpoints[0].vpce_specs : {}
    hybrid_dns_specs = local.enable_dnse ? module.hybrid_dns[0].hybrid_dns_specs : {
      inbound_dns_resolver_endpoints = []
      dns_resolver_rules             = []
    }
  }
}

# output "nw_shared_svc_tgw_attachment_id" {
#   description = "TGW attachment id for network shared services VPC."
#   value       = module.shared_services_vpc.nw_shared_svc_tgw_attachment_id
# }

output "supported_vpce_service_codes" {
  description = "List of supported service codes for VPC endpoints."
  value       = local.enable_vpce ? module.vpc_endpoints[0].supported_service_codes : {}
}
