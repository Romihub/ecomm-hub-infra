# modules/database/main.tf
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "${var.prefix}-psql"
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "14"
  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  #disable public network access
  public_network_access_enabled = false

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  storage_mb = var.storage_mb
  sku_name   = var.sku_name

  backup_retention_days = var.environment == "prod" ? 35 : 7

  zone = "1"

  lifecycle {
    ignore_changes = [
      administrator_password
    ]
  }
  high_availability {
    mode                      = var.environment == "prod" ? "ZoneRedundant" : "SameZone"
    standby_availability_zone = var.environment == "prod" ? "2" : null
  }

  tags = var.tags
}


resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}


resource "azurerm_postgresql_flexible_server_firewall_rule" "postgresql_firewall_rule" {
  name             = "AllowAll"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# Add PostgreSQL configurations
resource "azurerm_postgresql_flexible_server_configuration" "max_connections" {
  server_id = azurerm_postgresql_flexible_server.postgres.id
  name      = "max_connections"
  value     = var.environment == "prod" ? "200" : "50"
}

#GB
resource "azurerm_postgresql_flexible_server_configuration" "shared_buffers" {
  server_id = azurerm_postgresql_flexible_server.postgres.id
  name      = "shared_buffers"
  value     = var.environment == "prod" ? "32" : "16"
}

#MB
resource "azurerm_postgresql_flexible_server_configuration" "work_mem" {
  server_id = azurerm_postgresql_flexible_server.postgres.id
  name      = "work_mem"
  value     = var.environment == "prod" ? "8100" : "4096"
}

#MB
resource "azurerm_postgresql_flexible_server_configuration" "maintenance_work_mem" {
  server_id = azurerm_postgresql_flexible_server.postgres.id
  name      = "maintenance_work_mem"
  value     = var.environment == "prod" ? "2048" : "1024"
}

#resource "azurerm_postgresql_flexible_server_configuration" "effective_cache_size" {
#  server_id = azurerm_postgresql_flexible_server.postgres.id
#  name      = "effective_cache_size"
#  value     = var.environment == "prod" ? "24" : "1"
#}


resource "azurerm_postgresql_flexible_server_configuration" "timezone" {
  server_id = azurerm_postgresql_flexible_server.postgres.id
  name      = "timezone"
  value     = "UTC"
}

# Optional: Connection Pooling settings if needed
resource "azurerm_postgresql_flexible_server_configuration" "pgbouncer_enabled" {
  count     = var.enable_connection_pooling ? 1 : 0
  server_id = azurerm_postgresql_flexible_server.postgres.id
  name      = "pgbouncer.enabled"
  value     = "on"
}