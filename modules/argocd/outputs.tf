output "namespace" {
  value       = kubernetes_namespace_v1.this.metadata[0].name
  description = "Namespace where Argo CD is installed."
}

output "release_name" {
  value       = helm_release.this.name
  description = "Helm release name for Argo CD."
}
