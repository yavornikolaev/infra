# List of EC2 instance IDs
output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.ec2[*].id
}

# Public IPs (only if enabled)
output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.ec2[*].public_ip
}

# Private IPs
output "private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.ec2[*].private_ip
}

# Instance ARNs
output "instance_arns" {
  description = "ARNs of the created EC2 instances"
  value       = aws_instance.ec2[*].arn
}

# Instance availability zones
output "availability_zones" {
  description = "Availability Zones of the EC2 instances"
  value       = aws_instance.ec2[*].availability_zone
}

# Root volume IDs (attached to each instance)
output "root_volume_ids" {
  description = "Root EBS volume IDs for each EC2 instance"
  value       = aws_instance.ec2[*].root_block_device[0].volume_id
}