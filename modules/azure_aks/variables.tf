variable "name" {
  type        = string
  description = "AKS cluster name."
}

variable "location" {
  type        = string
  description = "Azure region (e.g., westeurope)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS API server."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the AKS node pool."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version (e.g., 1.33.6)."
}

variable "node_vm_size" {
  type        = string
  description = "Node pool VM size."
}

variable "node_count" {
  type        = number
  description = "Initial node count."
}

variable "node_min_count" {
  type        = number
  description = "Minimum node count for autoscaling."
}

variable "maintenance_window" {
  type = object({
    allowed = optional(list(object({
      day   = string
      hours = list(number)
    })))
    not_allowed = optional(list(object({
      start = string
      end   = string
    })))
  })
  description = "AKS maintenance window settings (allowed/not_allowed)."
  default     = null
}

variable "maintenance_window_auto_upgrade" {
  type = object({
    frequency    = string
    interval     = number
    duration     = number
    day_of_week  = optional(string)
    day_of_month = optional(number)
    week_index   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    start_date   = optional(string)
    not_allowed = optional(list(object({
      start = string
      end   = string
    })))
  })
  description = "AKS auto-upgrade maintenance window settings."
  default     = null
}

variable "maintenance_window_node_os" {
  type = object({
    frequency    = string
    interval     = number
    duration     = number
    day_of_week  = optional(string)
    day_of_month = optional(number)
    week_index   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    start_date   = optional(string)
    not_allowed = optional(list(object({
      start = string
      end   = string
    })))
  })
  description = "AKS node OS maintenance window settings."
  default     = null
}


variable "node_max_count" {
  type        = number
  description = "Maximum node count for autoscaling."
}

variable "node_os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB for nodes."
  default     = 30
}

variable "node_pools" {
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = number
    min_count           = number
    max_count           = number
    os_disk_size_gb     = number
    mode                = string
    enable_auto_scaling = bool
    vnet_subnet_id      = string
  }))
  description = "Additional AKS node pools."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to AKS resources."
  default     = {}
}
