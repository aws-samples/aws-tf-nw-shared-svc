output "vpc_id" {
  description = "VPC Id for the provisioned VPC"
  value       = module.shared_services_vpc.vpc_attributes.id
}

output "vpc_attributes" {
  description = "VPC attributes for the provisioned VPC"
  value       = module.shared_services_vpc.vpc_attributes
}

output "super_net_cidr_blocks" {
  description = "Super Net CIDR Blocks used for routing."
  value       = local.use_super_net_cidr_blocks ? var.super_net_cidr_blocks : []
}

output "azs" {
  description = "List of AZs where subnets are created."
  value       = module.shared_services_vpc.azs
}

output "private_subnet_attributes_by_az" {
  description = "List of private subnet attributes by AZ."
  value       = module.shared_services_vpc.private_subnet_attributes_by_az
}

output "supported_network_segments" {
  description = "List of supported network segments by NSS."
  value       = local.supported_network_segments
}

output "nw_shared_svc_prefix_list_id" {
  description = "Prefix list id for NSS."
  value       = aws_ec2_managed_prefix_list.nss_pl.id
}

output "nw_segment_prefix_list_ids" {
  description = "Prefix list id for network segment(s)."
  value       = { for nw_segment in local.supported_network_segments : nw_segment => aws_ec2_managed_prefix_list.nw_segment_pl[nw_segment].id }
}

output "nw_shared_svc_tgw_id" {
  description = "Transit GW Id that enables network shared services VPC."
  value       = module.shared_tgw.tgw_id
}

output "nw_shared_svc_tgw_attachment_id" {
  description = "TGW attachment id for network shared services VPC."
  value       = module.shared_services_vpc.transit_gateway_attachment_id
}

output "nw_shared_svc_tgw_route_table_id" {
  description = "TGW route table id for network shared services VPC."
  value       = aws_ec2_transit_gateway_route_table.nss_vpc_tgw_rt.id
}

output "nw_segment_tgw_route_table_ids" {
  description = "TGW route table id for network segment(s)."
  value       = { for nw_segment in local.supported_network_segments : nw_segment => aws_ec2_transit_gateway_route_table.nw_segment_tgw_rt[nw_segment].id }
}
