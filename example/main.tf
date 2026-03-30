module "managed_redis" {
  source = "../"

  env       = var.env
  product   = "myapp"
  component = "cache"
  project   = "sds"
  common_tags = {
    "managedBy"    = "Terraform"
    "environment"  = var.env
    "application"  = "core"
    "businessArea" = "Cross-Cutting"
    "expiresAfter" = "2027-01-01"
    "builtFrom"    = "https://github.com/hmcts/terraform-module-azure-managed-redis"
  }

  # SKU — Balanced_B3 (~6 GB, zone-redundant, suitable for non-prod / small prod)
  # Increase to Balanced_B5, B10 etc for larger workloads
  sku_name = "Balanced_B3"

  location                  = "UK South"
  high_availability_enabled = true

  # Disable public access and route traffic via private endpoint
  public_network_access = "Disabled"
  #   subnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-vnet-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/redis-subnet"
  #   private_dns_zone_ids  = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-dns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.redisenterprise.cache.azure.net"]

  # Database settings
  access_keys_authentication_enabled = false # Use EntraID / RBAC auth
  client_protocol                    = "Encrypted"
  clustering_policy                  = "OSSCluster"
  eviction_policy                    = "VolatileLRU"

  # Uncomment for RDB persistence (cannot be combined with geo-replication)
  # persistence_rdb_backup_frequency = "6h"

  # Uncomment to enable Redis modules
  # redis_modules = [
  #   { name = "RediSearch" },
  #   { name = "RedisJSON" },
  # ]
}

output "redis_hostname" {
  value = module.managed_redis.hostname
}

output "redis_port" {
  value = module.managed_redis.port
}
