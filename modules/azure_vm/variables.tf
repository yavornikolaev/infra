variable "name" {
  type        = string
  description = "Name of the virtual machine."
}

variable "location" {
  type        = string
  description = "Azure region (e.g., westeurope)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the NIC."
}

variable "network_security_group_id" {
  type        = string
  description = "Optional NSG ID to associate with the NIC."
  default     = null
}

variable "create_nsg" {
  type        = bool
  description = "Whether to create and attach a simple NSG (SSH only)."
  default     = false
}

variable "nsg_name" {
  type        = string
  description = "Optional NSG name when create_nsg is true."
  default     = null
}

variable "ssh_source_cidrs" {
  type        = list(string)
  description = "Allowed CIDRs for SSH when create_nsg is true."
  default     = ["0.0.0.0/0"]
}

variable "allow_http" {
  type        = bool
  description = "Whether to allow inbound HTTP (port 80) when create_nsg is true."
  default     = false
}

variable "http_source_cidrs" {
  type        = list(string)
  description = "Allowed CIDRs for HTTP when allow_http is true."
  default     = ["0.0.0.0/0"]
}

variable "vm_size" {
  type        = string
  description = "VM size (e.g., Standard_B1s)."
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the admin user."
}

variable "disable_password_authentication" {
  type        = bool
  description = "Disable password authentication for SSH."
  default     = true
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB."
  default     = 30
}

variable "enable_public_ip" {
  type        = bool
  description = "Whether to attach a public IP."
  default     = true
}

variable "image_publisher" {
  type        = string
  description = "Image publisher (e.g., Canonical)."
}

variable "image_offer" {
  type        = string
  description = "Image offer (e.g., 0001-com-ubuntu-server-jammy)."
}

variable "image_sku" {
  type        = string
  description = "Image SKU (e.g., 22_04-lts)."
}

variable "image_version" {
  type        = string
  description = "Image version (e.g., latest)."
}

variable "custom_data" {
  type        = string
  description = "Cloud-init or custom data (base64-encoded)."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Azure resources."
  default     = {}
}
