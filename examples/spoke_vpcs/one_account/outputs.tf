output "vpc_vpce_phz_assoc" {
  description = "List of private hosted zone associations with VPCs."
  value       = module.connected_vpcs.vpc_vpce_phz_assoc
}

output "vpc_dns_resolver_rule_assoc" {
  description = "List of DNS resolver rules associations with VPCs."
  value       = module.connected_vpcs.vpc_dns_resolver_rule_assoc
}
