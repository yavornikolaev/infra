variable "namespace" {
  type        = string
  description = "Kubernetes namespace to install Argo CD into."
  default     = "argocd"
}

variable "release_name" {
  type        = string
  description = "Helm release name."
  default     = "argocd"
}

variable "repository" {
  type        = string
  description = "Helm repository URL."
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart" {
  type        = string
  description = "Helm chart name."
  default     = "argo-cd"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version."
  default     = "7.7.0"
}

variable "values_file" {
  type        = string
  description = "Path to a values.yaml file to pass to the chart."
  default     = null
}
