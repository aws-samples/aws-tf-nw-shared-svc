resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count = local.create_cw_log_group ? 1 : 0

  name              = local.cw_log_group
  retention_in_days = 7
  kms_key_id        = length(data.aws_kms_key.logs_cmk) != 0 ? data.aws_kms_key.logs_cmk[0].arn : null

  tags = merge(
    {
      Name = local.cw_log_group
    },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      retention_in_days,
      kms_key_id
    ]
  }
}

data "aws_cloudwatch_log_group" "vpc_flow_log" {
  count = local.enable_flow_log && local.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name = local.create_cw_log_group ? aws_cloudwatch_log_group.vpc_flow_log[0].id : var.flow_log_specs.destination_name

  depends_on = [
    aws_cloudwatch_log_group.vpc_flow_log
  ]
}
