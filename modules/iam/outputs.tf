output "instance_profile_name" {
  description = "Instance profile name to attach to EC2"
  value       = aws_iam_instance_profile.this.name
}

output "role_name" {
  description = "IAM role name"
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.this.arn
}