resource "aws_iam_role" "delegate_role" {
  count    = local.create_delegate_role ? 1 : 0
  provider = aws.delegated

  name               = local.delegated_role_name
  description        = "This role is assumed by the Terraform User from the Terraform Admin Account"
  assume_role_policy = data.aws_iam_policy_document.delegate_assume_role[count.index].json
  #permissions_boundary = "arn-for-permission-boundary"

  #tags = var.tags
}

resource "aws_iam_role_policy" "delegated_terraform_role" {
  count    = local.create_delegate_role ? 1 : 0
  provider = aws.delegated

  name   = "TerraformDelegatedAccess"
  role   = aws_iam_role.delegate_role[0].id
  policy = local.delegated_access_policy
}
