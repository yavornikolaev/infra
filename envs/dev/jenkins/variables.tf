variable "aws_region" {
  default = "eu-central-1"
}

variable "ami_id" {
  type        = string
  description = "Optional override AMI ID"
  default     = "" # empty → module uses ubuntu image automatically
}