resource "aws_s3_bucket" "resolver_query_log" {
  # checkov:skip=CKV2_AWS_6: Ensure that S3 bucket has a Public Access block - enabled via resource
  # checkov:skip=CKV_AWS_18: Ensure the S3 bucket has access logging enabled - not required
  # checkov:skip=CKV_AWS_19: encrypted
  # checkov:skip=CKV_AWS_21: Ensure all data stored in the S3 bucket have versioning enabled - enabled via resource
  # checkov:skip=CKV2_AWS_61: Ensure that an S3 bucket has a lifecycle configuration - enabled via resource
  # checkov:skip=CKV2_AWS_62: Ensure S3 buckets should have event notifications enabled - not required
  # checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled - not required
  # checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default - optional via kms-alias
  count = local.create_s3 ? 1 : 0

  bucket        = local.bucket_name
  force_destroy = true

  tags = merge(
    {
      Name = local.bucket_name
    },
    var.tags
  )
}

resource "aws_s3_bucket_versioning" "resolver_query_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.resolver_query_log[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "resolver_query_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.resolver_query_log[0].id

  rule {
    object_ownership = "BucketOwnerEnforced" # BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "resolver_query_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.resolver_query_log[0].id
  rule {
    id     = "resolver_query_log_lifecycle"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "resolver_query_log" {
  count = length(data.aws_kms_key.s3_cmk) != 0 ? 1 : 0

  bucket = aws_s3_bucket.resolver_query_log[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = length(data.aws_kms_key.s3_cmk) != 0 ? data.aws_kms_key.s3_cmk[0].arn : null
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "resolver_query_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.resolver_query_log[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "resolver_query_log" {
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
      aws_s3_bucket.resolver_query_log[0].arn,
      "${aws_s3_bucket.resolver_query_log[0].arn}/*"
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
    resources = [
      "${aws_s3_bucket.resolver_query_log[0].arn}/AWSLogs/${local.account_id}/*"
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
        local.account_id
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:${local.partition}:logs:${local.region}:${local.account_id}:*"
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
      aws_s3_bucket.resolver_query_log[0].arn
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        local.account_id
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:${local.partition}:logs:${local.region}:${local.account_id}:*"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "resolver_query_log" {
  count = local.create_s3 ? 1 : 0

  bucket = aws_s3_bucket.resolver_query_log[0].id
  policy = data.aws_iam_policy_document.resolver_query_log[0].json
}

data "aws_s3_bucket" "resolver_query_log" {
  count = local.enable_resolver_query_log && local.resolver_query_log_destination_type == "s3" ? 1 : 0

  bucket = local.create_s3 ? aws_s3_bucket.resolver_query_log[0].id : var.resolver_query_log_specs.destination_name

  depends_on = [
    aws_s3_bucket.resolver_query_log
  ]
}
