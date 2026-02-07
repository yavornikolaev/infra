variable "name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane."
  type        = string
  default     = "1.33"
}

variable "endpoint_public_access" {
  description = "Amazon EKS public API server endpoint is enabled/disabled."
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Amazon EKS public API server endpoint is enabled/disabled."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster and node groups."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "eks_managed_node_group_defaults" {
  description = "Defaults applied to all EKS managed node groups."
  type        = any
  default     = {}
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node groups."
  type        = any
  default     = {}
}
