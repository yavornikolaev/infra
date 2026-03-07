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

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  description = "Client certificate for Kubernetes authentication (base64 encoded)."
  sensitive   = true
}

output "client_key" {
  value       = azurerm_kubernetes_cluster.this.kube_config[0].client_key
  description = "Client key for Kubernetes authentication (base64 encoded)."
  sensitive   = true
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  description = "Cluster CA certificate (base64 encoded)."
  sensitive   = true
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.this.node_resource_group
  description = "Resource group containing the node pool resources."
}
