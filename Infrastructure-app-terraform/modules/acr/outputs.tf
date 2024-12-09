output "acr_id" {
  value       = azurerm_container_registry.acr.id
  description = "The ID of the Container Registry"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server URL for the Container Registry"
}

output "acr_admin_username" {
  value       = azurerm_container_registry.acr.admin_username
  description = "The admin username for the Container Registry"
}

#output "private_dns_zone_id" {
#  value       = azurerm_private_dns_zone.acr.id
#  description = "The ID of the private DNS zone"
#}

#output "identity_principal_id" {
#  value       = azurerm_container_registry.acr.identity[0].principal_id
#  description = "The Principal ID of the Container Registry's managed identity"
#}