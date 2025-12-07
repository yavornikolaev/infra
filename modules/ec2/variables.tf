variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}


variable "ami_id" {
  type        = string
  default     = ""
  description = "Override AMI ID. If empty, module will use latest Ubuntu AMI."
}

variable "key_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}

variable "root_volume_size" {
  type = number
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "name_prefix" {
  type    = string
  default = "ec2"
}

output "ssh_user" {
  value = "ubuntu"
}

variable "tags" {
  type    = map(string)
  default = {}
}
