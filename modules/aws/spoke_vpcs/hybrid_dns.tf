resource "aws_route53_resolver_rule_association" "dnse_out" {
  for_each = { for vpc_rule in local.vpc_dns_resolver_rule_assoc : "${vpc_rule.vpc_name_prefix}-${vpc_rule.domain_name}" => vpc_rule }

  resolver_rule_id = each.value.rule_id
  vpc_id           = each.value.vpc_id
}
