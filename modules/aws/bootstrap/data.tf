data "aws_caller_identity" "admin" {
  provider = aws.admin
}

data "aws_caller_identity" "delegated" {
  provider = aws.delegated
}

data "aws_iam_policy" "admin_full_access_policy" {
  count    = local.create_delegate_role ? 1 : 0
  provider = aws.delegated

  name = "AdministratorAccess"
}

data "aws_iam_policy_document" "delegate_assume_role" {
  count    = local.create_delegate_role ? 1 : 0
  provider = aws.delegated

  statement {
    sid = "AllowAssumeRoleToTerraformAdminAccountUser"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.admin.arn]
    }
    actions = ["sts:AssumeRole"]
  }
}
