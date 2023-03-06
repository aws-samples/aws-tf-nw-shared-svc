output "vpc_vpce_phz_assoc" {
  description = "List of private hosted zone associations with VPCs."
  value       = local.vpc_vpce_phz_assoc
}

output "vpc_dns_resolver_rule_assoc" {
  description = "List of DNS resolver rules associations with VPCs."
  value       = local.vpc_dns_resolver_rule_assoc
}

output "test_ec2_instances" {
  description = "List of test EC2 instances"
  value       = { for k, v in aws_instance.private : k => v.id }
}
