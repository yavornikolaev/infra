output "server_name" {
  value       = azurerm_postgresql_flexible_server.this.name
  description = "PostgreSQL server name."
}

output "fqdn" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "PostgreSQL server FQDN."
}

output "database_name" {
  value       = azurerm_postgresql_flexible_server_database.this.name
  description = "Database name."
}

output "admin_username" {
  value       = azurerm_postgresql_flexible_server.this.administrator_login
  description = "Admin username."
}

output "admin_password" {
  value       = local.admin_password_value
  description = "Admin password."
  sensitive   = true
}
