variable "name_prefix" {
  type        = string
  description = "Prefix for resource names."
}

variable "location" {
  type        = string
  description = "Azure region (e.g., westeurope)."
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR block for the virtual network."
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the subnet."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Azure resources."
  default     = {}
}
