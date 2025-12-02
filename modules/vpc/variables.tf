variable "name" {
  description = "Name prefix used for tagging all VPC resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet where resources have internet access."
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet used for internal resources with no internet exposure."
  type        = string
  default     = "10.10.2.0/24"
}

variable "az1" {
  description = "AWS Availability Zone to deploy the subnets into."
  type        = string
  default     = "eu-central-1a"
}