# Networking Module Outputs

# Virtual Network
output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the Virtual Network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the Virtual Network"
}

# Subnet IDs
output "aks_subnet_id" {
  value       = azurerm_subnet.aks.id
  description = "The ID of the AKS subnet"
}

output "db_subnet_id" {
  value       = azurerm_subnet.db.id
  description = "The ID of the database subnet"
}

output "redis_subnet_id" {
  value       = azurerm_subnet.redis.id
  description = "The ID of the Redis subnet"
}

output "appgw_subnet_id" {
  value       = azurerm_subnet.appgw.id
  description = "The ID of the Application Gateway subnet"
}

# NSG IDs
output "aks_nsg_id" {
  value       = azurerm_network_security_group.aks.id
  description = "The ID of the AKS NSG"
}

output "appgw_nsg_id" {
  value       = azurerm_network_security_group.appgw.id
  description = "The ID of the Application Gateway NSG"
}

# Private DNS Zones
output "postgres_dns_zone_id" {
  value       = azurerm_private_dns_zone.postgres.id
  description = "The ID of the PostgreSQL Private DNS Zone"
}

output "redis_dns_zone_id" {
  value       = azurerm_private_dns_zone.redis.id
  description = "The ID of the Redis Private DNS Zone"
}