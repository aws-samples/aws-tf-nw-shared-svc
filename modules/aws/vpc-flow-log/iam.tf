data "aws_iam_policy_document" "flow_log_assume_role" {
  count = local.create_flow_log_role ? 1 : 0

  statement {
    sid = "AllowAssumeRoleToFlowLog"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:vpc-flow-log/*"]
    }
  }
}

data "aws_iam_policy_document" "flow_log_cw" {
  count = local.create_flow_log_role ? 1 : 0

  statement {
    sid = "AllowVPCFlowLogToCloudWatchLogs"
    actions = [
      #"logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${local.cw_log_group}*:*"
    ]
  }
}

resource "aws_iam_role" "flow_log_role" {
  count = local.create_flow_log_role ? 1 : 0

  name               = local.flow_log_role
  description        = "This role is assumed by the VPC flow log service to log to Cloud Watch or S3"
  assume_role_policy = data.aws_iam_policy_document.flow_log_assume_role[count.index].json
  #permissions_boundary = "arn-for-permission-boundary"
}

resource "aws_iam_role_policy" "flow_log_role" {
  count = local.create_flow_log_role ? 1 : 0

  name   = "${local.flow_log_role}Policy"
  role   = aws_iam_role.flow_log_role[0].id
  policy = data.aws_iam_policy_document.flow_log_cw[0].json
}

data "aws_iam_role" "flow_log_role" {
  count = local.enable_flow_log && local.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name = local.create_flow_log_role ? aws_iam_role.flow_log_role[0].name : local.flow_log_role
}
