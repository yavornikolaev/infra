variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "env" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT gatewa"
  type        = bool
  default     = false
}