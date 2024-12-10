output "test_ec2_instances" {
  description = "List of test EC2 instances"
  value       = { for k, v in aws_instance.private : k => v.id }
}

output "test_sg" {
  description = "test security groups"
  value       = { for k, v in aws_security_group.test_sg : k => v.id }
}

output "test_iam_role" {
  description = "test IAM role"
  value       = local.create_test_ec2 ? aws_iam_role.ec2_role[0].arn : ""
}

output "test_iam_instance_profile" {
  description = "test IAM instance profile"
  value       = local.create_test_ec2 ? aws_iam_instance_profile.ec2_role[0].arn : ""
}
