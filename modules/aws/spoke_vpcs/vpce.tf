resource "aws_route53_vpc_association_authorization" "vpce" {
  for_each = { for vpc_phz in local.vpc_vpce_phz_assoc : "${vpc_phz.vpc_name_prefix}-${vpc_phz.service_code}" => vpc_phz }
  provider = aws.hub

  vpc_id  = each.value.vpc_id
  zone_id = each.value.zone_id
}

resource "aws_route53_zone_association" "vpce" {
  for_each = aws_route53_vpc_association_authorization.vpce
  vpc_id   = aws_route53_vpc_association_authorization.vpce[each.key].vpc_id
  zone_id  = aws_route53_vpc_association_authorization.vpce[each.key].zone_id
}
