output "backend_config" {
  description = "Define the backend configuration with following values"
  value       = <<-EOT
bucket = "${local.create_s3_state_bucket ? aws_s3_bucket.tfstate[0].id : ""}"
dynamodb_table = "${local.create_dynamodb_lock_table ? aws_dynamodb_table.tfstate[0].name : ""}"
region = "${var.region}"
#key = "create-your-own-key-here"
EOT
}

output "delegated_role_arn" {
  description = "Delegated Role ARN"
  value       = local.create_delegate_role ? aws_iam_role.delegate_role[0].arn : ""
}
