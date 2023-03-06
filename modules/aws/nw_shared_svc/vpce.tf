module "vpc_endpoints" {
  source = "../vpc_endpoints"
  count  = local.enable_vpce ? 1 : 0

  region = var.region

  project  = var.project
  env_name = var.env_name
  tags     = var.tags

  #Encryption
  kms_admin_roles = var.kms_admin_roles

  #Network
  #vpc_tags     = local.const_vpc_tags
  #subnet_tags = local.const_vpce_subnet_tags
  vpc_id = module.shared_services_vpc.vpc_id
  az_to_subnets = { for key, subnet in module.shared_services_vpc.private_subnet_attributes_by_az : subnet.availability_zone =>
    {
      id         = subnet.id
      cidr_block = subnet.cidr_block
      az_id      = subnet.availability_zone_id
    } if split("/", key)[0] == "vpce"
  }

  enable_flow_log = var.enable_vpce_flow_log
  flow_log_specs  = var.flow_log_specs

  #Test script (optional)
  generate_vpce_test_script = var.generate_vpce_test_script

  vpce_service_codes = var.vpce_service_codes

  flow_log_service_codes = var.vpce_flow_log_service_codes
}
