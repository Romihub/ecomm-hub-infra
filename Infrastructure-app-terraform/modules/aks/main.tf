# modules/aks/main.tf
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-aks"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = var.system_node_vm_size
    vnet_subnet_id      = var.subnet_id
    enable_auto_scaling = true
    min_count           = var.system_node_min_count
    max_count           = var.system_node_max_count

    # System nodes should be on-demand for stability
    # priority            = "Regular"
  }

  identity {
    type = "SystemAssigned"
  }

   #csi addon
  key_vault_secrets_provider {
    secret_rotation_enabled  = var.enable_secret_rotation
    #secret_rotation_interval = "2m"    # Optional: Configure rotation interval
  }

  # Enable OIDC and Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"

    # Use different range for services
    service_cidr       = "172.16.0.0/16"  # Different range
    dns_service_ip     = "172.16.0.10"    # Within service_cidr
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = var.tags
}

# On-demand node pool for critical workloads
resource "azurerm_kubernetes_cluster_node_pool" "ondemand" {
  name                  = "ondemand"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.ondemand_node_vm_size
  vnet_subnet_id        = var.subnet_id
  priority              = "Regular"

  enable_auto_scaling  = true
  min_count = var.ondemand_node_min_count
  max_count = var.ondemand_node_max_count

  node_labels = {
    "nodepool-type" = "ondemand"
    "environment"   = var.environment
  }

  node_taints = []

  tags = var.tags
}

# Spot instance node pool for cost optimization
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.spot_node_vm_size
  vnet_subnet_id        = var.subnet_id
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = var.spot_price_max

  enable_auto_scaling  = true
  min_count = var.spot_node_min_count
  max_count = var.spot_node_max_count

  node_labels = {
    "nodepool-type" = "spot"
    "environment"   = var.environment
  }

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  tags = var.tags
}


# Role assignment for Key Vault access
resource "azurerm_role_assignment" "aks_keyvault" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

# Additional role assignment for CSI Driver
resource "azurerm_role_assignment" "aks_csi_keyvault" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

#https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver