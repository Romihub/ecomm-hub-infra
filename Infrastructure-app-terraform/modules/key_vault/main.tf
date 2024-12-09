# modules/key_vault/main.tf
resource "azurerm_key_vault" "dev-kv" {
  name                        = var.vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  tags                        = var.tags
}

data "azurerm_client_config" "current" {}