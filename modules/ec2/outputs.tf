output "instance_ids" {
  description = "EC2 instance IDs"
  value       = values(aws_instance.this)[*].id
}


output "public_ips" {
  description = "Public IP addresses"
  value       = values(aws_instance.this)[*].public_ip
}


output "private_ips" {
  description = "Private IP addresses"
  value       = values(aws_instance.this)[*].private_ip
}

output "key_names" {
  description = "Key names used for the EC2 instances"
  value       = values(aws_instance.this)[*].key_name
}

output "instance_arns" {
  description = "EC2 instance ARNs"
  value       = values(aws_instance.this)[*].arn
}


output "availability_zones" {
  description = "Availability Zones of the EC2 instances"
  value       = values(aws_instance.this)[*].availability_zone
}

output "root_volume_ids" {
  description = "Root EBS volume IDs for each EC2 instance"
  value       = values(aws_instance.this)[*].root_block_device[0].volume_id
}
