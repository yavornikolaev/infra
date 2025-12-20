variable "role_name" {
  description = "Name of the IAM role for EC2"
  type        = string
}

variable "tags" {
  description = "Tags applied to IAM resources"
  type        = map(string)
  default     = {}
}