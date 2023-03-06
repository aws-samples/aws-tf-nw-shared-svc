data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id   = try(length(var.vpc_id), 0) != 0 ? var.vpc_id : null
  tags = try(length(var.vpc_id), 0) != 0 ? null : var.vpc_tags
}

data "aws_subnets" "subnets" {
  count = try(length(var.subnet_tags), 0) != 0 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = var.subnet_tags
}

data "aws_subnet" "subnet" {
  for_each = try(length(var.subnet_tags), 0) != 0 ? toset(data.aws_subnets.subnets[0].ids) : toset([])
  id       = each.value
}

data "aws_vpc_endpoint_service" "vpce_service" {
  for_each = toset(var.vpce_service_codes)

  service      = contains(["s3-global.accesspoint", "notebook", "studio"], each.key) ? null : each.key
  service_name = contains(["s3-global.accesspoint", "notebook", "studio"], each.key) ? local.aws_services[each.key].name : null
  service_type = try(each.value.type, "Interface")
}

data "aws_kms_key" "logs_cmk" {
  count = local.flow_log_encrypted && local.create_cw_log_group && local.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  key_id = local.logs_kms_alias

  depends_on = [
    module.vpce_kms
  ]
}

data "aws_kms_key" "s3_cmk" {
  count = local.flow_log_encrypted && local.create_s3 && local.flow_log_destination_type == "s3" ? 1 : 0

  key_id = local.s3_kms_alias

  depends_on = [
    module.vpce_kms
  ]
}
