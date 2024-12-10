# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "hub-ecommdev-rg"
  location = "uksouth"
  
  tags = {
    Environment = "Development"
    Project     = "E-commerce"
    ManagedBy   = "Terraform"
  }
  lifecycle {
      prevent_destroy = false
  }
}

# Networking
module "network" {
  source              = "../../modules/network"
  prefix              = "ecom-dev"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name
  vnet_cidr           = "10.0.0.0/16"
  aks_subnet_cidr     = "10.0.0.0/22"
  db_subnet_cidr      = "10.0.4.0/24"
  redis_subnet_cidr   = "10.0.5.0/24"
  appgw_subnet_cidr   = "10.0.6.0/24"

  private_endpoint_network_policies = "Enabled"

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}


# Application Gateway
module "application_gateway" {
  source              = "../../modules/application_gateway"
  prefix              = "ecom-dev"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name
  environment         = "dev"

  subnet_id = module.network.appgw_subnet_id

  capacity     = 2
  min_capacity = 1
  max_capacity = 3

  enable_https       = true
  
  ssl_certificate_data           = null
  ssl_certificate_password       = null

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}


# ACR
module "acr" {
  source              = "../../modules/acr"
  prefix              = "ecom-dev"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name
  environment         = "dev"

  subnet_id                  = module.network.aks_subnet_id
  vnet_id                    = module.network.vnet_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  # Standard tier for dev, no geo-replication
  geo_replications = []

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}

# AKS
module "aks" {
  source                     = "../../modules/aks"
  prefix                     = "ecom-dev"
  location                   = "uksouth"
  resource_group_name        = azurerm_resource_group.main.name
  environment                = "dev"
  kubernetes_version         = "1.30"
  subnet_id                  = module.network.aks_subnet_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  # Key Vault integration
  key_vault_id              = module.key_vault.key_vault_id

  depends_on = [
    module.key_vault
  ]
  
  enable_secret_rotation    = true
  #secret_rotation_interval  = "2m"
  enable_keyvault_secrets_store_driver = true

  # System node pool
  system_node_count     = 1
  system_node_vm_size   = "Standard_D2s_v3"
  system_node_min_count = 1
  system_node_max_count = 3

  # On-demand node pool
  ondemand_node_vm_size   = "Standard_D4s_v3"
  ondemand_node_min_count = 1
  ondemand_node_max_count = 5

  # Spot node pool
  spot_node_vm_size   = "Standard_D2s_v3"
  spot_node_min_count = 0
  spot_node_max_count = 10
  spot_price_max      = -1

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}


# Redis Cache
module "redis" {
  source              = "../../modules/redis"
  prefix              = "ecom-dev"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name

  #requires a Premium sku to be set
  subnet_id           = module.network.redis_subnet_id

  private_dns_zone_id = module.network.redis_dns_zone_id

  capacity           = 1
  family             = "C"
  sku_name           = "Standard"
  maxmemory_reserved = 50
  maxmemory_delta    = 50

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}

# PostgreSQL Database
module "postgresql" {
  source              = "../../modules/postgresql"
  prefix              = "ecom-dev"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name
  environment         = "dev"

  enable_connection_pooling = false

  subnet_id           = module.network.db_subnet_id
  private_dns_zone_id = module.network.postgres_dns_zone_id

  admin_username = "myuser"
  admin_password = "!rdmyWatgcg14" # Should be stored in Key Vault in practice

  database_name = "ecommerce"
  storage_mb    = 32768
  sku_name      = "GP_Standard_D2s_v3"

  db_configurations = {
    max_connections        = "50"
    shared_buffers        = "16"
    work_mem             = "4096"
    maintenance_work_mem  = "1024"
  }

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}


# Monitoring
module "monitoring" {
  source              = "../../modules/monitoring"
  prefix              = "ecom-dev"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name
  environment         = "dev"
  aks_cluster_id      = module.aks.cluster_id

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}

# Key Vault
module "key_vault" {
  source              = "../../modules/key_vault"
  vault_name          = "ecom-dev-kv216"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = "Development"
    Project     = "E-commerce"
  }
}
