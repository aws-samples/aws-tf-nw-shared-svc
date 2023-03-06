module "vpce_kms" {
  source = "github.com/aws-samples/aws-tf-kms//modules/aws/kms?ref=v1.0.0"
  count  = local.create_kms ? 1 : 0

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  kms_alias_prefix = var.project
  kms_admin_roles  = var.kms_admin_roles
  kms_usage_roles  = []

  enable_kms_logs = local.create_logs_kms
  enable_kms_s3   = local.create_s3_kms
}
