# modules/database/outputs.tf
output "server_id" {
  value       = azurerm_postgresql_flexible_server.postgres.id
  description = "The ID of the PostgreSQL Server"
}

output "server_name" {
  value       = azurerm_postgresql_flexible_server.postgres.name
  description = "The name of the PostgreSQL Server"
}

output "server_fqdn" {
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
  description = "The FQDN of the PostgreSQL Server"
}

output "database_name" {
  value       = azurerm_postgresql_flexible_server_database.main.name
  description = "The name of the PostgreSQL Database"
}

output "connection_string" {
  value       = "postgresql://${var.admin_username}@${azurerm_postgresql_flexible_server.postgres.name}:${var.admin_password}@${azurerm_postgresql_flexible_server.postgres.fqdn}:5432/${azurerm_postgresql_flexible_server_database.main.name}"
  sensitive   = true
  description = "PostgreSQL connection string"
}