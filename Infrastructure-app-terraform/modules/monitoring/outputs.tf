# modules/monitoring/outputs.tf
output "workspace_id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "The ID of the Log Analytics Workspace"
}

output "workspace_name" {
  value       = azurerm_log_analytics_workspace.main.name
  description = "The name of the Log Analytics Workspace"
}

output "workspace_key" {
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
  description = "The primary shared key of the Log Analytics Workspace"
}

output "workspace_customer_id" {
  value       = azurerm_log_analytics_workspace.main.workspace_id
  description = "The Workspace (Customer) ID of the Log Analytics Workspace"
}