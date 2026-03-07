output "postgres_fqdn" {
  value       = module.postgres.fqdn
  description = "PostgreSQL server FQDN."
}

output "postgres_db_name" {
  value       = module.postgres.database_name
  description = "PostgreSQL database name."
}

output "postgres_admin_username" {
  value       = module.postgres.admin_username
  description = "PostgreSQL admin username."
}

output "postgres_admin_password" {
  value       = module.postgres.admin_password
  description = "PostgreSQL admin password."
  sensitive   = true
}
