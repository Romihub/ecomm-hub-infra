# modules/app-gateway/outputs.tf
output "application_gateway_id" {
  value       = azurerm_application_gateway.main.id
  description = "The ID of the Application Gateway"
}

output "application_gateway_name" {
  value       = azurerm_application_gateway.main.name
  description = "The name of the Application Gateway"
}

output "public_ip_address" {
  value       = azurerm_public_ip.gateway.ip_address
  description = "The public IP address of the Application Gateway"
}

output "public_ip_fqdn" {
  value       = azurerm_public_ip.gateway.fqdn
  description = "The FQDN of the Application Gateway public IP"
}

#output "backend_address_pool_id" {
#  value       = azurerm_application_gateway.main.backend_address_pool[0].id
#  description = "The ID of the default backend address pool"
#}

output "backend_address_pool_id" {
  value       = [for pool in azurerm_application_gateway.main.backend_address_pool : pool.id if pool.name == "aks-backend-pool"][0]
  description = "The ID of the AKS backend address pool"
}

# If you need a specific probe by name
output "health_probe_id" {
  value       = [for probe in azurerm_application_gateway.main.probe : probe.id if probe.name == "aks-probe"][0]
  description = "The ID of the default health probe"
}


#output "health_probe_id" {
#  value       = azurerm_application_gateway.main.probe[0].id
#  description = "The ID of the default health probe"
#}

