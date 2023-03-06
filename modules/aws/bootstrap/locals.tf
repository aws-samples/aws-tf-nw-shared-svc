locals {
  # either force creation (in the same account too), or only when needed
  create_delegate_role = var.delegated_access_only || data.aws_caller_identity.admin.account_id != data.aws_caller_identity.delegated.account_id ? true : false
  delegated_role_name  = try(length(var.delegated_role_name), 0) == 0 ? "Terraformer" : var.delegated_role_name

  create_dynamodb_lock_table = var.delegated_access_only || try(length(var.dynamo_locktable_name), 0) == 0 ? false : true
  create_s3_state_bucket     = var.delegated_access_only || try(length(var.s3_statebucket_name), 0) == 0 ? false : true

  delegated_access_policy = local.create_delegate_role && try(
    length(var.delegated_access_policy), 0) == 0 ? data.aws_iam_policy.admin_full_access_policy[0].policy : try(
  length(var.delegated_access_policy), 0) == 0 ? "" : var.delegated_access_policy
}
