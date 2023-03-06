resource "aws_s3_bucket" "vpce_flow_log" {
  # checkov:skip=CKV_AWS_18: not required
  # checkov:skip=CKV_AWS_19: encrypted
  # checkov:skip=CKV_AWS_21: versioned
  # checkov:skip=CKV_AWS_144: not required
  # checkov:skip=CKV_AWS_145: not required
  count = local.create_s3 ? 1 : 0

  bucket_prefix = local.bucket_name_prefix
  force_destroy = true

  tags = merge(
    {
      Name = "${var.project}-vpce-vpc-flow-logs"
    },
    var.tags
  )
}

resource "aws_s3_bucket_versioning" "vpce_flow_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.vpce_flow_log[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_acl" "vpce_flow_log" {
#   count = local.create_s3 ? 1 : 0

#   bucket = aws_s3_bucket.vpce_flow_log[0].id
#   acl    = "private"
# }

resource "aws_s3_bucket_ownership_controls" "vpce_flow_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.vpce_flow_log[0].id

  rule {
    object_ownership = "BucketOwnerEnforced" # BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "vpce_flow_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.vpce_flow_log[0].id
  rule {
    id     = "vpce_flow_log_lifecycle"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpce_flow_log" {
  count = length(data.aws_kms_key.s3_cmk) != 0 ? 1 : 0

  bucket = aws_s3_bucket.vpce_flow_log[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = length(data.aws_kms_key.s3_cmk) != 0 ? data.aws_kms_key.s3_cmk[0].arn : null
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "vpce_flow_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.vpce_flow_log[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "vpce_flow_log" {
  count = local.create_s3 ? 1 : 0

  statement {
    sid = "Allow access to bucket only via TLS"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.vpce_flow_log[0].arn,
      "${aws_s3_bucket.vpce_flow_log[0].arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }

  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = local.hive_compatible_partitions ? [
      "${aws_s3_bucket.vpce_flow_log[0].arn}/${local.log_prefix}/AWSLogs/aws-account-id=${data.aws_caller_identity.current.account_id}/*"
      ] : [
      "${aws_s3_bucket.vpce_flow_log[0].arn}/${local.log_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      aws_s3_bucket.vpce_flow_log[0].arn
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "vpce_flow_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.vpce_flow_log[0].id
  policy = data.aws_iam_policy_document.vpce_flow_log[0].json
}

data "aws_s3_bucket" "vpce_flow_log" {
  count = local.enable_flow_log && local.flow_log_destination_type == "s3" ? 1 : 0

  bucket = local.create_s3 ? aws_s3_bucket.vpce_flow_log[0].id : var.flow_log_specs.destination_name

  depends_on = [
    aws_s3_bucket.vpce_flow_log
  ]
}
