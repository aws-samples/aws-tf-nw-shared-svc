output "vpc_id" {
  description = "VPC Id for the provisioned VPC"
  value       = module.nw_shared_svc.vpc_id
}

output "vpc_attributes" {
  description = "VPC attributes for the provisioned VPC"
  value       = module.nw_shared_svc.vpc_attributes
}

output "nss_attributes" {
  description = "Network Shared Services attributes, used by spoke_vpcs module."
  value       = module.nw_shared_svc.nss_attributes
}

output "azs" {
  description = "List of AZs where subnets are created."
  value       = module.nw_shared_svc.azs
}

output "private_subnet_attributes_by_az" {
  description = "List of private subnet attributes by AZ."
  value       = module.nw_shared_svc.private_subnet_attributes_by_az
}


# output "supported_vpce_service_codes" {
#   description = "List of supported service codes for VPC endpoints."
#   value       = module.nw_shared_svc.supported_vpce_service_codes
# }
