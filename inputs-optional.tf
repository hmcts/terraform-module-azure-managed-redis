variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  default     = ""
  description = "The default name will be product+component+env, you can override the product+component part by setting this"
}

# ─── Managed Redis SKU & availability ────────────────────────────────────────

variable "sku_name" {
  description = <<-EOT
    The SKU for the Managed Redis instance.
    Format is <Tier>_<Size>, e.g. Balanced_B3, ComputeOptimized_X5.
    Tiers: Balanced (B), ComputeOptimized (X), FlashOptimized (A), MemoryOptimized (M).
    Sizes: B0/B1/B3/B5/B10/B20/B50/B100/B150/B250/B350/B500/B700/B1000,
           X3/X5/X10/X20/X50/X100/X150/X250/X350/X500/X700,
           A250/A500/A700/A1000/A1500/A2000/A4500,
           M10/M20/M50/M100/M150/M250/M350/M500/M700/M1000/M1500/M2000.
  EOT
  type        = string
  default     = "Balanced_B3"
}

variable "high_availability_enabled" {
  description = "Whether to enable high availability for the Managed Redis instance. Defaults to true. Changing this forces a new resource."
  type        = bool
  default     = true
}

variable "public_network_access" {
  description = "Public network access setting. Possible values are Enabled and Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "public_network_access must be 'Enabled' or 'Disabled'."
  }
}

# ─── Default database settings ───────────────────────────────────────────────

variable "access_keys_authentication_enabled" {
  description = "Whether access key authentication is enabled for the database. Defaults to false (EntraID/RBAC auth only)."
  type        = bool
  default     = false
}

variable "client_protocol" {
  description = "Whether redis clients connect using TLS-encrypted or plaintext protocols. Possible values: Encrypted, Plaintext."
  type        = string
  default     = "Encrypted"

  validation {
    condition     = contains(["Encrypted", "Plaintext"], var.client_protocol)
    error_message = "client_protocol must be 'Encrypted' or 'Plaintext'."
  }
}

variable "clustering_policy" {
  description = "Clustering policy. Possible values: EnterpriseCluster, OSSCluster, NoCluster. Changing this forces database recreation."
  type        = string
  default     = "OSSCluster"

  validation {
    condition     = contains(["EnterpriseCluster", "OSSCluster", "NoCluster"], var.clustering_policy)
    error_message = "clustering_policy must be 'EnterpriseCluster', 'OSSCluster', or 'NoCluster'."
  }
}

variable "eviction_policy" {
  description = "Redis eviction policy. Possible values: AllKeysLFU, AllKeysLRU, AllKeysRandom, VolatileLRU, VolatileLFU, VolatileTTL, VolatileRandom, NoEviction."
  type        = string
  default     = "VolatileLRU"

  validation {
    condition = contains(
      ["AllKeysLFU", "AllKeysLRU", "AllKeysRandom", "VolatileLRU", "VolatileLFU", "VolatileTTL", "VolatileRandom", "NoEviction"],
      var.eviction_policy
    )
    error_message = "eviction_policy must be one of the valid Redis eviction policies."
  }
}

variable "geo_replication_group_name" {
  description = "Name of the geo-replication group. If set, links the database into an active geo-replication group. Cannot be combined with persistence settings. Changing this forces database recreation."
  type        = string
  default     = null

  validation {
    condition = var.geo_replication_group_name == null || (
      var.persistence_aof_backup_frequency == null && var.persistence_rdb_backup_frequency == null
    )
    error_message = "geo_replication_group_name cannot be combined with persistence_aof_backup_frequency or persistence_rdb_backup_frequency."
  }
}

variable "persistence_aof_backup_frequency" {
  description = "Frequency of Append Only File (AOF) backups. The only valid value is '1s'. Conflicts with persistence_rdb_backup_frequency and geo_replication_group_name."
  type        = string
  default     = null

  validation {
    condition     = var.persistence_aof_backup_frequency == null || var.persistence_aof_backup_frequency == "1s"
    error_message = "persistence_aof_backup_frequency only supports the value '1s'."
  }
}

variable "persistence_rdb_backup_frequency" {
  description = "Frequency of Redis Database (RDB) backups. Possible values: 1h, 6h, 12h. Conflicts with persistence_aof_backup_frequency and geo_replication_group_name."
  type        = string
  default     = null

  validation {
    condition     = var.persistence_rdb_backup_frequency == null || contains(["1h", "6h", "12h"], var.persistence_rdb_backup_frequency)
    error_message = "persistence_rdb_backup_frequency must be '1h', '6h', or '12h'."
  }
}

variable "redis_modules" {
  description = "List of Redis modules to enable. Each entry must have a 'name' key. Optional 'args' key for module configuration. Possible names: RedisBloom, RedisTimeSeries, RediSearch, RedisJSON. Changing this forces database recreation."
  type = list(object({
    name = string
    args = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for m in var.redis_modules : contains(["RedisBloom", "RedisTimeSeries", "RediSearch", "RedisJSON"], m.name)
    ])
    error_message = "Valid module names are: RedisBloom, RedisTimeSeries, RediSearch, RedisJSON."
  }
}

# ─── Private endpoint ─────────────────────────────────────────────────────────

variable "subnet_id" {
  description = "ID of the subnet used to create a private endpoint for the Managed Redis instance. Required when public_network_access is Disabled."
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs to associate with the private endpoint. Typically the zone for privatelink.redisenterprise.cache.azure.net."
  type        = list(string)
  default     = []
}

# ─── Managed identity ─────────────────────────────────────────────────────────

variable "identity_type" {
  description = "The type of managed identity to assign. Possible values: SystemAssigned, UserAssigned, 'SystemAssigned, UserAssigned'. Leave null to omit identity."
  type        = string
  default     = null
}

variable "identity_ids" {
  description = "List of User Assigned Managed Identity IDs. Required when identity_type includes UserAssigned."
  type        = list(string)
  default     = null
}

# ─── Customer-managed key ─────────────────────────────────────────────────────

variable "customer_managed_key" {
  description = "Customer-managed key configuration for at-rest encryption. Requires identity_type to include UserAssigned."
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = string
  })
  default = null
}

# ─── HashiCorp Vault ──────────────────────────────────────────────────────────

variable "enable_vault_secret" {
  description = "When true, the primary and secondary access keys are written to HashiCorp Vault at secret/terraform/<environment>/managedredis/<name>. Requires access_keys_authentication_enabled = true."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name used in the Vault secret path (e.g. dev, staging, production). Defaults to the value of var.env if not set. Kept for compatibility with cpp-module-terraform-azurerm-redis."
  type        = string
  default     = ""
}

variable "vault_secret_path_prefix" {
  description = "Path prefix used when writing secrets to Vault. Defaults to 'secret/terraform'."
  type        = string
  default     = "secret/terraform"
}

# ─── Tagging compatibility ────────────────────────────────────────────────────

variable "tags" {
  description = "Additional tags to merge with common_tags. Provided for compatibility with cpp-module-terraform-azurerm-redis which uses 'tags' instead of 'common_tags'."
  type        = map(string)
  default     = {}
}
