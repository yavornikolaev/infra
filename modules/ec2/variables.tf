variable "instance_names" {
  description = "Set of instance name suffixes"
  type        = set(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "Optional AMI ID override"
  type        = string
  default     = null
}

variable "instance_profile_name" {
  description = "IAM instance profile name (SSM role)"
  type        = string
}


variable "key_name" {
  description = "SSH key name (optional, can be null when using SSM)"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Associate public IP address (true for Free Tier)"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}


variable "subnet_id" {
  description = "Subnet ID where EC2 will be launched"
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size (GB)"
  type        = number
  default     = 8 
}

variable "user_data" {
  description = "Optional cloud-init user data"
  type        = string
  default     = null
}


variable "name_prefix" {
  description = "Name prefix for EC2 instances"
  type        = string
}


variable "tags" {
  description = "Tags applied to EC2 instances"
  type        = map(string)
  default     = {}
}
