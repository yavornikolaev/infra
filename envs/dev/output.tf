output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID for dev environment"
}

output "public_subnets" {
  value       = module.vpc.public_subnet_ids
}

output "ec2_security_group_id" {
  value       = module.ec2_sg.security_group_id
}

output "ec2_instance_ids" {
  value       = module.ec2.instance_ids
}

output "ec2_public_ips" {
  value       = module.ec2.public_ips
}

output "ec2_private_ips" {
  value       = module.ec2.private_ips
}
