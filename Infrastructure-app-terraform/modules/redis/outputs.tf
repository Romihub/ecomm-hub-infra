
output "hostname" {
  description = "The hostname of the Redis instance"
  value       = azurerm_redis_cache.redis.hostname
}

output "ssl_port" {
  description = "The SSL port of the Redis instance"
  value       = azurerm_redis_cache.redis.ssl_port
}

output "primary_access_key" {
  description = "The primary access key for the Redis instance"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}