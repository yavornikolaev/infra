output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.ec2[*].id
}


output "public_ips" {
  description = "Public IP addresses"
  value       = aws_instance.ec2[*].public_ip
}


output "private_ips" {
  description = "Private IP addresses"
  value       = aws_instance.ec2[*].private_ip
}


output "instance_arns" {
  description = "EC2 instance ARNs"
  value       = aws_instance.ec2[*].arn
}


output "availability_zones" {
  description = "Availability Zones of the EC2 instances"
  value       = aws_instance.ec2[*].availability_zone
}

output "root_volume_ids" {
  description = "Root EBS volume IDs for each EC2 instance"
  value       = aws_instance.ec2[*].root_block_device[0].volume_id
}

