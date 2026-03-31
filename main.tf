resource "azurerm_managed_redis" "redis" {
  name                = "${local.name}-${var.env}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  sku_name            = var.sku_name

  high_availability_enabled = var.high_availability_enabled
  public_network_access     = var.public_network_access

  default_database {
    access_keys_authentication_enabled            = var.access_keys_authentication_enabled
    client_protocol                               = var.client_protocol
    clustering_policy                             = var.clustering_policy
    eviction_policy                               = var.eviction_policy
    geo_replication_group_name                    = var.geo_replication_group_name
    persistence_append_only_file_backup_frequency = var.persistence_aof_backup_frequency
    persistence_redis_database_backup_frequency   = var.persistence_rdb_backup_frequency

    dynamic "module" {
      for_each = var.redis_modules
      content {
        name = module.value.name
        args = module.value.args
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [var.customer_managed_key] : []
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = customer_managed_key.value.user_assigned_identity_id
    }
  }

  tags = local.merged_tags

  lifecycle {
    precondition {
      condition     = !contains([for m in var.redis_modules : m.name], "RediSearch") || var.eviction_policy == "NoEviction"
      error_message = "When using the RediSearch module, eviction_policy must be set to 'NoEviction'."
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "redis_diag" {
  count = var.enable_diagnostic_settings ? 1 : 0

  name                           = var.diagnostic_settings_name != "" ? var.diagnostic_settings_name : "${local.name}-${var.env}-diag"
  target_resource_id             = azurerm_managed_redis.redis.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  storage_account_id             = var.diagnostic_storage_account_id
  eventhub_name                  = var.diagnostic_eventhub_name
  eventhub_authorization_rule_id = var.diagnostic_eventhub_authorization_rule_id

  dynamic "enabled_log" {
    for_each = var.diagnostic_log_categories != null ? var.diagnostic_log_categories : []
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.diagnostic_metric_categories != null ? var.diagnostic_metric_categories : ["AllMetrics"]
    content {
      category = metric.value
    }
  }
}

resource "azurerm_private_endpoint" "redis_pe" {
  count = var.subnet_id != null ? 1 : 0

  name                = "${local.name}-${var.env}-pe"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.name}-${var.env}-psc"
    private_connection_resource_id = azurerm_managed_redis.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisEnterprise"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "${local.name}-${var.env}-dns-group"
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }

  tags = local.merged_tags
}
