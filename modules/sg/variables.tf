variable "vpc_id" {
  type = string
}

variable "name" {
  type = string
}

# New: allow passing multiple ingress rules
variable "ingress_rules" {
  description = "List of ingress rules objects"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = []
}
