#VPC level
resource "aws_route53_resolver_query_log_config" "resolver_query_log" {
  count = local.enable_resolver_query_log ? 1 : 0

  name = "resolver-query-log-config-${local.account_id}"

  destination_arn = local.resolver_query_log_destination_type == "cloud-watch-logs" ? data.aws_cloudwatch_log_group.resolver_query_log[0].arn : data.aws_s3_bucket.resolver_query_log[0].arn

  tags = merge(
    {
      Name = "resolver-query-log-config-${local.account_id}"
    },
    var.tags
  )
}

resource "aws_route53_resolver_query_log_config_association" "resolver_query_log" {
  for_each = local.enable_resolver_query_log ? toset(var.vpc_ids) : toset([])

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.resolver_query_log[0].id
  resource_id                  = each.value
}

# TODO Sharing to OUs,in case of S3
