# modules/acr/main.tf
resource "azurerm_container_registry" "acr" {
  name                = replace("${var.prefix}acr", "-", "")  # ACR name cannot contain hyphens
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.environment == "prod" ? "Premium" : "Standard"
  admin_enabled       = false  # Best practice: Use managed identity instead

  ## Premium tier features
  #dynamic "georeplications" {
  #  for_each = var.environment == "prod" && var.geo_replications != null ? var.geo_replications : []
  #  content {
  #    location                = georeplications.value
  #    zone_redundancy_enabled = true
  #  }
  #}

  #Only for Premium tier
  #public_network_access_enabled = false  # Disable public access
  #network_rule_set {
  #  default_action = "Deny"
  #}

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

#For Premium tier
# Private endpoint for ACR
#resource "azurerm_private_endpoint" "acr" {
#  name                = "${var.prefix}-acr-pe"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  subnet_id           = var.subnet_id

#  private_service_connection {
#    name                           = "${var.prefix}-acr-privateserviceconnection"
#    private_connection_resource_id = azurerm_container_registry.acr.id
#    subresource_names             = ["registry"]
#    is_manual_connection          = false
#  }

#  private_dns_zone_group {
#    name                 = "acr-dns-group"
#    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
#  }
#}

# Private DNS zone for ACR
#resource "azurerm_private_dns_zone" "acr" {
#  name                = "privatelink.azurecr.io"
#  resource_group_name = var.resource_group_name
#}

#resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
#  name                  = "${var.prefix}-acr-link"
#  resource_group_name   = var.resource_group_name
#  private_dns_zone_name = azurerm_private_dns_zone.acr.name
#  virtual_network_id    = var.vnet_id
#}

# Grant AKS pull access to ACR
#resource "azurerm_role_assignment" "aks_acr_pull" {
#  scope                = azurerm_container_registry.acr.id
#  role_definition_name = "AcrPull"
#  principal_id         = var.aks_principal_id
#}

# Diagnostic settings for ACR
resource "azurerm_monitor_diagnostic_setting" "acr" {
  name                       = "${var.prefix}-acr-diag"
  target_resource_id        = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}