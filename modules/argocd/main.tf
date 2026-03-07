terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
  }
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  name             = var.release_name
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  create_namespace = false

  values = var.values_file == null ? [] : [file(var.values_file)]
}
