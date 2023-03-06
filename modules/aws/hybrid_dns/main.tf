resource "aws_security_group" "dnse_in" {
  # checkov:skip=CKV2_AWS_5: SG is attached in the resource module
  # checkov:skip=CKV_AWS_23: N/A
  count = local.enable_inbound_dnse ? 1 : 0

  name        = "dns-inbound-resolver-${var.project}-${var.env_name}-sg"
  description = "Allow inbound DNS traffic to DNS resolvers"
  vpc_id      = local.vpc_id

  tags = merge(
    {
      Name = "dns-inbound-resolver-${var.project}-${var.env_name}-sg"
    },
    var.tags,
    var.dnse_tags
  )
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "dnse_in_egress_tcp" {
  count = local.enable_inbound_dnse ? 1 : 0

  description       = "Allow ingress tcp to on-premises for DNS query"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = var.on_premises_cidrs
  security_group_id = aws_security_group.dnse_in[0].id
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "dnse_in_egress_udp" {
  count = local.enable_inbound_dnse ? 1 : 0

  description       = "Allow ingress udp to on-premises for DNS query"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = var.on_premises_cidrs
  security_group_id = aws_security_group.dnse_in[0].id
}

resource "aws_route53_resolver_endpoint" "dnse_in" {
  count = local.enable_inbound_dnse ? 1 : 0

  name      = "dns-inbound-resolver-${var.project}-${var.env_name}-ep"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.dnse_in[0].id
  ]

  dynamic "ip_address" {
    for_each = local.subnets
    content {
      subnet_id = ip_address.value.subnet_id
      ip        = cidrhost(ip_address.value.cidr_block, 5)
    }
  }

  tags = merge(
    {
      Name = "dns-inbound-resolver-${var.project}-${var.env_name}-ep"
    },
    var.tags,
    var.dnse_tags
  )
}

resource "aws_security_group" "dnse_out" {
  # checkov:skip=CKV2_AWS_5: SG is attached in the resource module
  # checkov:skip=CKV_AWS_23: N/A
  count = local.enable_outbound_dnse ? 1 : 0

  name        = "dns-outbound-resolver-${var.project}-${var.env_name}-sg"
  description = "Allow outbound DNS traffic to DNS resolvers"
  vpc_id      = local.vpc_id

  tags = merge(
    {
      Name = "dns-outbound-resolver-${var.project}-${var.env_name}-sg"
    },
    var.tags,
    var.dnse_tags
  )
}

#TODO avoid dup
#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "dnse_out_egress_tcp" {
  count = local.enable_outbound_dnse ? 1 : 0

  description       = "Allow egress tcp to on-premises for DNS query"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = [for ip in local.outbound_dns_ips : "${ip}/32"]
  security_group_id = aws_security_group.dnse_out[0].id
}

#TODO avoid dup
#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "dnse_out_egress_udp" {
  count = local.enable_outbound_dnse ? 1 : 0

  description       = "Allow egress udp to on-premises for DNS query"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [for ip in local.outbound_dns_ips : "${ip}/32"]
  security_group_id = aws_security_group.dnse_out[0].id
}

resource "aws_route53_resolver_endpoint" "dnse_out" {
  count = local.enable_outbound_dnse ? 1 : 0

  name      = "dns-outbound-resolver-${var.project}-${var.env_name}-ep"
  direction = "OUTBOUND"

  security_group_ids = [
    aws_security_group.dnse_out[0].id
  ]

  dynamic "ip_address" {
    for_each = local.subnets
    content {
      subnet_id = ip_address.value.subnet_id
      ip        = cidrhost(ip_address.value.cidr_block, 4)
    }
  }

  tags = merge(
    {
      Name = "dns-outbound-resolver-${var.project}-${var.env_name}-ep"
    },
    var.tags,
    var.dnse_tags
  )
}

resource "aws_route53_resolver_rule" "dnse_out" {
  for_each = { for config in var.outbound_dns_resolver_config : config.domain_name => config }

  domain_name          = each.key
  name                 = replace("${each.key}-${var.project}-${var.env_name}-forward-rule", ".", "-")
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.dnse_out[0].id

  dynamic "target_ip" {
    for_each = each.value.target_ip_addresses
    content {
      ip = target_ip.value
    }
  }

  tags = merge(
    {
      Name = replace("${each.key}-${var.project}-${var.env_name}-forward-rule", ".", "-")
    },
    var.tags,
    var.dnse_tags
  )
}

resource "aws_route53_resolver_rule_association" "dnse_out" {
  for_each = { for config in var.outbound_dns_resolver_config : config.domain_name => config }

  resolver_rule_id = aws_route53_resolver_rule.dnse_out[each.key].id
  vpc_id           = local.vpc_id
}
