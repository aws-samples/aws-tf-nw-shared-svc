locals {
  enable_flow_log           = var.enable_flow_log
  flow_log_encrypted        = local.enable_flow_log && try(var.flow_log_specs.encrypted && true, true) ? true : false
  flow_log_destination_type = try(length(var.flow_log_specs.destination_type), 0) != 0 ? var.flow_log_specs.destination_type : "cloud-watch-logs"

  enable_vpce_subnet_flow_log = local.enable_flow_log && try(length(var.flow_log_service_codes), 0) == 0
  enable_vpce_eni_flow_log    = local.enable_flow_log && try(length(var.flow_log_service_codes), 0) != 0
  vpce_eni_flow_logs = local.enable_vpce_eni_flow_log ? merge([
    for key, vpce in local.service_code_apex_alias : {
      for eni in vpce.network_interface_ids : "${key}-${eni}" => {
        service_code         = key
        network_interface_id = eni
      }
    }
    if contains(var.flow_log_service_codes, key)
  ]...) : {}

  max_aggregation_interval = try(abs(var.flow_log_specs.max_aggregation_interval), 0) == 0 ? 600 : var.flow_log_specs.max_aggregation_interval
  traffic_type             = try(length(var.flow_log_specs.traffic_type), 0) == 0 ? "ALL" : var.flow_log_specs.traffic_type

  #flow log role
  create_flow_log_role = local.enable_flow_log && local.flow_log_destination_type == "cloud-watch-logs" && try(
  length(var.flow_log_specs.flow_log_role), 0) == 0 ? true : false
  flow_log_role = try(length(var.flow_log_specs.flow_log_role
  ), 0) == 0 ? "SharedServices-NW-VPCE-FlowLog-Role-${var.project}-${var.env_name}" : var.flow_log_specs.flow_log_role

  #CW destination
  create_cw_log_group = local.enable_flow_log && local.flow_log_destination_type == "cloud-watch-logs" && try(
  length(var.flow_log_specs.destination_name), 0) == 0 ? true : false
  cw_log_group = try(length(var.flow_log_specs.destination_name), 0) == 0 ? "/${var.project}/${var.env_name}/nw-shared-svc/vpce/vpc-flow-logs" : var.flow_log_specs.destination_name

  #S3 destination
  create_s3 = local.enable_flow_log && local.flow_log_destination_type == "s3" && try(
  length(var.flow_log_specs.destination_name), 0) == 0 ? true : false
  bucket_name_prefix = "nw-shared-svc-vpce-flow-logs"
  log_prefix         = "${var.project}/${var.env_name}/nw-shared-svc/vpce"

  #for S3
  file_format                = try(length(var.flow_log_specs.file_format), 0) == 0 ? "plain-text" : var.flow_log_specs.file_format
  per_hour_partition         = try(var.flow_log_specs.per_hour_partition && true, false) ? true : false
  hive_compatible_partitions = try(var.flow_log_specs.hive_compatible_partitions && true, false) ? true : false

  #flow log encryption
  create_logs_kms = local.flow_log_encrypted && local.create_cw_log_group && try(
  length(var.flow_log_specs.kms_alias), 0) == 0 ? true : false
  logs_kms_alias = try(length(var.flow_log_specs.kms_alias), 0) == 0 ? "alias/${var.project}/logs" : var.flow_log_specs.kms_alias
  create_s3_kms = local.flow_log_encrypted && local.create_s3 && try(
  length(var.flow_log_specs.kms_alias), 0) == 0 ? true : false
  s3_kms_alias = try(length(var.flow_log_specs.kms_alias), 0) == 0 ? "alias/${var.project}/s3" : var.flow_log_specs.kms_alias
  create_kms   = local.create_logs_kms || local.create_s3_kms ? true : false
}

#subnet level
resource "aws_flow_log" "vpce_subnet" {
  for_each = local.enable_vpce_subnet_flow_log ? local.az_to_subnet : {}

  #Role needed only for CW, not for S3
  iam_role_arn = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_iam_role.flow_log_role[0].arn : null

  log_destination_type = local.flow_log_destination_type
  log_destination      = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_cloudwatch_log_group.vpce_flow_log[0].arn : "${data.aws_s3_bucket.vpce_flow_log[0].arn}/${local.log_prefix}"

  traffic_type             = local.traffic_type
  max_aggregation_interval = local.max_aggregation_interval

  subnet_id = each.value.id

  dynamic "destination_options" {
    for_each = local.flow_log_destination_type == "s3" ? ["1"] : []
    content {
      file_format                = local.file_format
      hive_compatible_partitions = local.hive_compatible_partitions
      per_hour_partition         = local.per_hour_partition
    }
  }

  tags = merge(
    {
      #TODO, include service_code for eni-level
      Name = "${var.project}-${each.key}-all-vpce-vpc-flow-logs"
    },
    var.tags
  )
}

#ENI level
resource "aws_flow_log" "vpce_eni" {
  for_each = local.vpce_eni_flow_logs

  #Role needed only for CW, not for S3
  iam_role_arn = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_iam_role.flow_log_role[0].arn : null

  log_destination_type = local.flow_log_destination_type
  log_destination      = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_cloudwatch_log_group.vpce_flow_log[0].arn : "${data.aws_s3_bucket.vpce_flow_log[0].arn}/${local.log_prefix}"

  traffic_type             = local.traffic_type
  max_aggregation_interval = local.max_aggregation_interval

  eni_id = each.value.network_interface_id

  dynamic "destination_options" {
    for_each = local.flow_log_destination_type == "s3" ? ["1"] : []
    content {
      file_format                = local.file_format
      hive_compatible_partitions = local.hive_compatible_partitions
      per_hour_partition         = local.per_hour_partition
    }
  }

  tags = merge(
    {
      Name = "${var.project}-${each.key}-vpce-vpc-flow-logs"
    },
    var.tags
  )
}
