output "hybrid_dns_specs" {
  description = <<-EOF
  Hybrid DNS specs.
  `inbound_dns_resolver_endpoints`, Inbound DNS Resolver Endpoint(s) to be used to configure On-premises DNS server(s)
  `dns_resolver_rules`, DNS resolver rules that are shared.
  EOF
  value = {
    inbound_dns_resolver_endpoints = local.enable_inbound_dnse ? [for ip in aws_route53_resolver_endpoint.dnse_in[0].ip_address : ip.ip] : []
    dns_resolver_rules = local.enable_outbound_dnse ? [for rule in aws_route53_resolver_rule.dnse_out : {
      id                   = rule.id
      domain_name          = rule.domain_name
      rule_type            = rule.rule_type
      resolver_endpoint_id = rule.resolver_endpoint_id
    }] : []
  }
}
