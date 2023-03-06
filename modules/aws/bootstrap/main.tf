resource "aws_dynamodb_table" "tfstate" {
  # checkov:skip=CKV_AWS_119: KMS encryption is not in scope
  # checkov:skip=CKV_AWS_28: Backup is not in scope
  count    = local.create_dynamodb_lock_table ? 1 : 0
  provider = aws.admin

  name         = var.dynamo_locktable_name
  billing_mode = "PAY_PER_REQUEST"
  #read_capacity  = 1
  #write_capacity = 1
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = false
  }
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "tfstate" {
  # checkov:skip=CKV_AWS_18: not required
  # checkov:skip=CKV_AWS_19: encrypted
  # checkov:skip=CKV_AWS_21: versioned
  # checkov:skip=CKV_AWS_144: not required
  # checkov:skip=CKV_AWS_145: not required
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

  bucket = var.s3_statebucket_name

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

  bucket = aws_s3_bucket.tfstate[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "tfstate" {
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

  bucket = aws_s3_bucket.tfstate[0].id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate" {
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

  bucket = aws_s3_bucket.tfstate[0].id
  rule {
    id     = "tfstate_lifecycle"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

  bucket = aws_s3_bucket.tfstate[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      #kms_master_key_id = "alias-if-available"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

  bucket = aws_s3_bucket.tfstate[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "tls_only" {
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

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
      aws_s3_bucket.tfstate[0].arn,
      "${aws_s3_bucket.tfstate[0].arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "tfstate" {
  count    = local.create_s3_state_bucket ? 1 : 0
  provider = aws.admin

  bucket = aws_s3_bucket.tfstate[0].id
  policy = data.aws_iam_policy_document.tls_only[0].json
}
