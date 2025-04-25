#VPC level
resource "aws_flow_log" "vpc_flow_log" {
  count = local.enable_vpc_level_flow_log ? 1 : 0

  #Role needed only for CW, not for S3
  iam_role_arn = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_iam_role.flow_log_role[0].arn : null

  log_destination_type = local.flow_log_destination_type
  log_destination      = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_cloudwatch_log_group.vpc_flow_log[0].arn : "${data.aws_s3_bucket.vpc_flow_log[0].arn}/${local.log_prefix}"

  traffic_type             = local.traffic_type
  max_aggregation_interval = local.max_aggregation_interval

  vpc_id = var.vpc_id

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
      Name = "vpc-flow-logs-${var.vpc_id}"
    },
    var.tags
  )
}

#subnet level
resource "aws_flow_log" "subnet_flow_log" {
  for_each = local.enable_subnet_level_flow_log ? toset(var.subnet_ids) : toset([])

  #Role needed only for CW, not for S3
  iam_role_arn = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_iam_role.flow_log_role[0].arn : null

  log_destination_type = local.flow_log_destination_type
  log_destination      = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_cloudwatch_log_group.vpc_flow_log[0].arn : "${data.aws_s3_bucket.vpc_flow_log[0].arn}/${local.log_prefix}"

  traffic_type             = local.traffic_type
  max_aggregation_interval = local.max_aggregation_interval

  subnet_id = each.value

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
      Name = "vpc-subnet-flow-logs-${each.value}"
    },
    var.tags
  )
}

#ENI level
resource "aws_flow_log" "eni_flow_log" {
  for_each = local.enable_eni_level_flow_log ? toset(var.eni_ids) : toset([])

  #Role needed only for CW, not for S3
  iam_role_arn = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_iam_role.flow_log_role[0].arn : null

  log_destination_type = local.flow_log_destination_type
  log_destination      = local.flow_log_destination_type == "cloud-watch-logs" ? data.aws_cloudwatch_log_group.vpc_flow_log[0].arn : "${data.aws_s3_bucket.vpc_flow_log[0].arn}/${local.log_prefix}"

  traffic_type             = local.traffic_type
  max_aggregation_interval = local.max_aggregation_interval

  eni_id = each.value

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
      Name = "vpc-eni-flow-logs-${each.value}"
    },
    var.tags
  )
}

# TODO transit_gateway_id, transit_gateway_attachment_id
