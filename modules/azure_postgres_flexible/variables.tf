variable "name" {
  type        = string
  description = "PostgreSQL Flexible Server name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "postgres_version" {
  type        = string
  description = "PostgreSQL version."
  default     = "16"
}

variable "admin_username" {
  type        = string
  description = "Administrator username."
  default     = "postgres"
}

variable "admin_password" {
  type        = string
  description = "Administrator password. If null, a random password is generated."
  default     = null
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "SKU name (e.g. B_Standard_B1ms)."
  default     = "B_Standard_B1ms"
}

variable "storage_gb" {
  type        = number
  description = "Storage in GB."
  default     = 32
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention in days."
  default     = 7
}

variable "storage_autogrow" {
  type        = string
  description = "Storage autogrow setting (Enabled/Disabled)."
  default     = "Disabled"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone (e.g. 1, 2, 3). Empty for none."
  default     = ""
}

variable "geo_redundant_backup" {
  type        = string
  description = "Geo-redundant backup (Enabled/Disabled)."
  default     = "Disabled"
}

variable "database_name" {
  type        = string
  description = "Default database name."
  default     = "appdb"
}

variable "allowed_ips" {
  type        = list(string)
  description = "Public IPs allowed to access the server."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Azure resources."
  default     = {}
}
