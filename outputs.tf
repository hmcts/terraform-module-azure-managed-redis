output "resource_group_name" {
  description = "The name of the resource group containing the Managed Redis instance."
  value       = local.resource_group_name
}

output "resource_group_location" {
  description = "The Azure region of the resource group."
  value       = local.resource_group_location
}

output "id" {
  description = "The ID of the Managed Redis instance."
  value       = azurerm_managed_redis.redis.id
}

output "hostname" {
  description = "The DNS hostname of the Managed Redis cluster endpoint."
  value       = azurerm_managed_redis.redis.hostname
}

output "default_database_id" {
  description = "The ID of the Managed Redis default database."
  value       = azurerm_managed_redis.redis.default_database[0].id
}

output "port" {
  description = "The TCP port of the database endpoint."
  value       = azurerm_managed_redis.redis.default_database[0].port
}

output "primary_access_key" {
  description = "The primary access key for the Managed Redis database. Only populated when access_keys_authentication_enabled is true."
  value       = azurerm_managed_redis.redis.default_database[0].primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the Managed Redis database. Only populated when access_keys_authentication_enabled is true."
  value       = azurerm_managed_redis.redis.default_database[0].secondary_access_key
  sensitive   = true
}

output "private_endpoint_id" {
  description = "The ID of the private endpoint, if created."
  value       = length(azurerm_private_endpoint.redis_pe) > 0 ? azurerm_private_endpoint.redis_pe[0].id : null
}

output "private_endpoint_ip_address" {
  description = "The private IP address of the private endpoint, if created."
  value       = length(azurerm_private_endpoint.redis_pe) > 0 ? azurerm_private_endpoint.redis_pe[0].private_service_connection[0].private_ip_address : null
}

# ─── Backward-compatible aliases (matching cpp-module-terraform-azurerm-redis) ─

output "redis_cache_instance_id" {
  description = "Alias for id — backward compatible with cpp-module-terraform-azurerm-redis."
  value       = azurerm_managed_redis.redis.id
}

output "redis_cache_hostname" {
  description = "Alias for hostname — backward compatible with cpp-module-terraform-azurerm-redis."
  value       = azurerm_managed_redis.redis.hostname
}

output "redis_cache_ssl_port" {
  description = "Alias for port — Managed Redis uses a single TLS port. Backward compatible with cpp-module-terraform-azurerm-redis."
  value       = azurerm_managed_redis.redis.default_database[0].port
}

output "redis_cache_primary_access_key" {
  description = "Alias for primary_access_key — backward compatible with cpp-module-terraform-azurerm-redis."
  value       = azurerm_managed_redis.redis.default_database[0].primary_access_key
  sensitive   = true
}

output "redis_cache_secondary_access_key" {
  description = "Alias for secondary_access_key — backward compatible with cpp-module-terraform-azurerm-redis."
  value       = azurerm_managed_redis.redis.default_database[0].secondary_access_key
  sensitive   = true
}

output "redis_cache_primary_connection_string" {
  description = "Constructed primary connection string in the format <hostname>:<port>,password=<key>,ssl=True. Only populated when access_keys_authentication_enabled is true."
  value       = var.access_keys_authentication_enabled ? "${azurerm_managed_redis.redis.hostname}:${azurerm_managed_redis.redis.default_database[0].port},password=${azurerm_managed_redis.redis.default_database[0].primary_access_key},ssl=True,abortConnect=False" : null
  sensitive   = true
}

output "redis_cache_secondary_connection_string" {
  description = "Constructed secondary connection string in the format <hostname>:<port>,password=<key>,ssl=True. Only populated when access_keys_authentication_enabled is true."
  value       = var.access_keys_authentication_enabled ? "${azurerm_managed_redis.redis.hostname}:${azurerm_managed_redis.redis.default_database[0].port},password=${azurerm_managed_redis.redis.default_database[0].secondary_access_key},ssl=True,abortConnect=False" : null
  sensitive   = true
}
