locals {
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  enable_resolver_query_log = var.enable_resolver_query_log
}

locals {
  resolver_query_log_destination_type = try(length(var.resolver_query_log_specs.destination_type), 0) != 0 ? var.resolver_query_log_specs.destination_type : "cloud-watch-logs"

  # #resolver_query log role
  # create_resolver_query_log_role = local.enable_resolver_query_log && local.resolver_query_log_destination_type == "cloud-watch-logs" && try(
  # length(var.resolver_query_log_specs.resolver_query_log_role), 0) == 0 ? true : false
  # resolver_query_log_role = try(length(var.resolver_query_log_specs.resolver_query_log_role
  # ), 0) == 0 ? "DefaultResolverQueryLogRole" : var.resolver_query_log_specs.resolver_query_log_role

  #CW destination
  create_cw_log_group = local.enable_resolver_query_log && local.resolver_query_log_destination_type == "cloud-watch-logs" && try(
  length(var.resolver_query_log_specs.destination_name), 0) == 0 ? true : false
  cw_log_group = try(length(var.resolver_query_log_specs.destination_name), 0) == 0 ? "/route53/dns-resolver-query-logs/${local.account_id}" : var.resolver_query_log_specs.destination_name

  #S3 destination
  create_s3 = local.enable_resolver_query_log && local.resolver_query_log_destination_type == "s3" && try(
  length(var.resolver_query_log_specs.destination_name), 0) == 0 ? true : false
  bucket_name = "dns-resolver-query-logs-${local.account_id}"

  #resolver_query log encryption
  resolver_query_log_encrypted = local.enable_resolver_query_log && try(var.resolver_query_log_specs.encrypted && true, true) && try(length(var.resolver_query_log_specs.kms_alias), 0) != 0 ? true : false
  kms_alias                    = try(length(var.resolver_query_log_specs.kms_alias), 0) == 0 ? null : var.resolver_query_log_specs.kms_alias
}
