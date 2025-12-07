# List of EC2 instance IDs
output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = module.ec2.instance_ids
}

# Public IPs
output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = module.ec2.public_ips
}

# Private IPs
output "private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.ec2.private_ips
}

output "vpc_id" {
  value = module.vpc.vpc_id
}