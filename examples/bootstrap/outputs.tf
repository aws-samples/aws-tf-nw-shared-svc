output "backend_config" {
  description = "Define the backend configuration with following values"
  value       = module.bootstrap.backend_config
}

output "network_account_role_arn" {
  description = "Delegated Role ARN for network account"
  value       = module.bootstrap_network_account_access.delegated_role_arn
}

output "dev_account_role_arn" {
  description = "Delegated Role ARN for dev account"
  value       = module.bootstrap_dev_account_access.delegated_role_arn
}

output "test_account_role_arn" {
  description = "Delegated Role ARN for test account"
  value       = module.bootstrap_test_account_access.delegated_role_arn
}

output "sec_account_role_arn" {
  description = "Delegated Role ARN for sec account"
  value       = module.bootstrap_sec_account_access.delegated_role_arn
}
