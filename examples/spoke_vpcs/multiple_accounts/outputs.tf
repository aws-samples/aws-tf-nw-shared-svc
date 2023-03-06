output "vpc_vpce_phz_assoc_dev" {
  description = "List of private hosted zone associations with VPCs."
  value       = module.connected_vpcs_dev.vpc_vpce_phz_assoc
}

output "vpc_dns_resolver_rule_assoc_dev" {
  description = "List of DNS resolver rules associations with VPCs."
  value       = module.connected_vpcs_dev.vpc_dns_resolver_rule_assoc
}

output "test_ec2_instances_dev" {
  description = "List of test EC2 instances"
  value       = module.connected_vpcs_dev.test_ec2_instances
}

output "vpc_vpce_phz_assoc_test" {
  description = "List of private hosted zone associations with VPCs."
  value       = module.connected_vpcs_test.vpc_vpce_phz_assoc
}

output "vpc_dns_resolver_rule_assoc_test" {
  description = "List of DNS resolver rules associations with VPCs."
  value       = module.connected_vpcs_test.vpc_dns_resolver_rule_assoc
}

output "test_ec2_instances_test" {
  description = "List of test EC2 instances"
  value       = module.connected_vpcs_test.test_ec2_instances
}
