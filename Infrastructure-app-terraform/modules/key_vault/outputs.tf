# Basic Key Vault information
output "key_vault_id" {
  value       = azurerm_key_vault.dev-kv.id
  description = "The ID of the Key Vault"
}

output "key_vault_name" {
  value       = azurerm_key_vault.dev-kv.name
  description = "The name of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.dev-kv.vault_uri
  description = "The URI of the Key Vault"
}

# Resource information
output "resource_group_name" {
  value       = azurerm_key_vault.dev-kv.resource_group_name
  description = "The name of the resource group in which the Key Vault is created"
}

output "location" {
  value       = azurerm_key_vault.dev-kv.location
  description = "The Azure region where the Key Vault is created"
}

# Tenant and identity information
output "tenant_id" {
  value       = azurerm_key_vault.dev-kv.tenant_id
  description = "The Azure AD tenant ID used for Key Vault"
}

# Security information (be careful with sensitive outputs)
output "sku_name" {
  value       = azurerm_key_vault.dev-kv.sku_name
  description = "The SKU name of the Key Vault"
}

output "enabled_for_disk_encryption" {
  value       = azurerm_key_vault.dev-kv.enabled_for_disk_encryption
  description = "Whether Key Vault is enabled for disk encryption"
}

output "purge_protection_enabled" {
  value       = azurerm_key_vault.dev-kv.purge_protection_enabled
  description = "Whether purge protection is enabled for this Key Vault"
}

output "soft_delete_retention_days" {
  value       = azurerm_key_vault.dev-kv.soft_delete_retention_days
  description = "The number of days that items should be retained for after soft-delete"
}

# Network related outputs
output "network_acls" {
  value = {
    default_action             = azurerm_key_vault.dev-kv.network_acls[0].default_action
    bypass                     = azurerm_key_vault.dev-kv.network_acls[0].bypass
    ip_rules                  = azurerm_key_vault.dev-kv.network_acls[0].ip_rules
    virtual_network_subnet_ids = azurerm_key_vault.dev-kv.network_acls[0].virtual_network_subnet_ids
  }
  description = "Network ACLs for the Key Vault"
}

# Tags
output "tags" {
  value       = azurerm_key_vault.dev-kv.tags
  description = "The tags assigned to the Key Vault"
}