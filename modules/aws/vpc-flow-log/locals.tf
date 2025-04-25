locals {
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  enable_flow_log = var.enable_flow_log

  enable_vpc_level_flow_log    = local.enable_flow_log && try(length(var.subnet_ids), 0) == 0 && try(length(var.eni_ids), 0) == 0 ? true : false
  enable_subnet_level_flow_log = local.enable_flow_log && try(length(var.subnet_ids), 0) != 0 && try(length(var.eni_ids), 0) == 0 ? true : false
  enable_eni_level_flow_log    = local.enable_flow_log && try(length(var.eni_ids), 0) != 0 ? true : false
}

locals {
  flow_log_destination_type = try(length(var.flow_log_specs.destination_type), 0) != 0 ? var.flow_log_specs.destination_type : "cloud-watch-logs"

  max_aggregation_interval = try(abs(var.flow_log_specs.max_aggregation_interval), 0) == 0 ? 600 : var.flow_log_specs.max_aggregation_interval
  traffic_type             = try(length(var.flow_log_specs.traffic_type), 0) == 0 ? "ALL" : var.flow_log_specs.traffic_type

  #flow log role
  create_flow_log_role = local.enable_flow_log && local.flow_log_destination_type == "cloud-watch-logs" && try(
  length(var.flow_log_specs.flow_log_role), 0) == 0 ? true : false
  flow_log_role = try(length(var.flow_log_specs.flow_log_role
  ), 0) == 0 ? "DefaultFlowLogRole-${var.vpc_id}" : var.flow_log_specs.flow_log_role

  #CW destination
  create_cw_log_group = local.enable_flow_log && local.flow_log_destination_type == "cloud-watch-logs" && try(
  length(var.flow_log_specs.destination_name), 0) == 0 ? true : false
  cw_log_group = try(length(var.flow_log_specs.destination_name), 0) == 0 ? "/vpc/vpc-flow-logs/${var.vpc_id}" : var.flow_log_specs.destination_name

  #S3 destination
  create_s3 = local.enable_flow_log && local.flow_log_destination_type == "s3" && try(
  length(var.flow_log_specs.destination_name), 0) == 0 ? true : false
  bucket_name = "vpc-flow-logs-${var.vpc_id}-${data.aws_caller_identity.current.account_id}"
  log_prefix  = var.vpc_id

  #for S3
  file_format                = try(length(var.flow_log_specs.file_format), 0) == 0 ? "plain-text" : var.flow_log_specs.file_format
  per_hour_partition         = try(var.flow_log_specs.per_hour_partition && true, false) ? true : false
  hive_compatible_partitions = try(var.flow_log_specs.hive_compatible_partitions && true, false) ? true : false

  #flow log encryption
  flow_log_encrypted = local.enable_flow_log && try(var.flow_log_specs.encrypted && true, true) && try(length(var.flow_log_specs.kms_alias), 0) != 0 ? true : false
  kms_alias          = try(length(var.flow_log_specs.kms_alias), 0) == 0 ? null : var.flow_log_specs.kms_alias
}
