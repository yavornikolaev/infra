# Public IPs
output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = module.jenkins.public_ips
}

output "ssh_user" {
  value = "ec2-user"
}

output "ssh_private_key_path" {
  value = pathexpand("~/.ssh/aws_key.pem")
}
