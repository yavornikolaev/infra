output "cluster_id" {
  value       = azurerm_kubernetes_cluster.this.id
  description = "AKS cluster ID."
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  description = "Raw kubeconfig for the cluster."
  sensitive   = true
}

output "host" {
  value       = azurerm_kubernetes_cluster.this.kube_config[0].host
  description = "Kubernetes API server endpoint."
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.this.node_resource_group
  description = "Resource group containing the node pool resources."
}
