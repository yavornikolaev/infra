terraform {
  required_version = ">= 1.5.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.azure_aks.host
  client_certificate     = base64decode(module.azure_aks.client_certificate)
  client_key             = base64decode(module.azure_aks.client_key)
  cluster_ca_certificate = base64decode(module.azure_aks.cluster_ca_certificate)
}

provider "helm" {
  kubernetes = {
    host                   = module.azure_aks.host
    client_certificate     = base64decode(module.azure_aks.client_certificate)
    client_key             = base64decode(module.azure_aks.client_key)
    cluster_ca_certificate = base64decode(module.azure_aks.cluster_ca_certificate)
  }
}
