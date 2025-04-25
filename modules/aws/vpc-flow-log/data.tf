data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_kms_key" "logs_cmk" {
  count = local.flow_log_encrypted && local.create_cw_log_group && local.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  key_id = local.kms_alias
}

data "aws_kms_key" "s3_cmk" {
  count = local.flow_log_encrypted && local.create_s3 && local.flow_log_destination_type == "s3" ? 1 : 0

  key_id = local.kms_alias
}
