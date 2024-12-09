# modules/redis/main.tf
resource "azurerm_redis_cache" "redis" {
  name                = "${var.prefix}-redis"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  #enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_reserved = var.maxmemory_reserved
    maxmemory_delta    = var.maxmemory_delta
    maxmemory_policy   = "allkeys-lru"
  }

  #subnet_id = var.subnet_id

  tags = var.tags

  lifecycle {
    ignore_changes = [
      redis_configuration["aad_enabled"],
      public_network_access_enabled
    ]
  }
}

resource "azurerm_private_endpoint" "redis" {
  name                = "${var.prefix}-redis-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-redis-privateserviceconnection"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "redis-dns-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}