resource "vault_generic_secret" "managed_redis_access_keys" {
  count = var.enable_vault_secret ? 1 : 0

  path = format("%s/%s/managedredis/%s-%s", var.vault_secret_path_prefix, local.vault_environment, local.name, var.env)

  data_json = jsonencode({
    primary_access_key   = azurerm_managed_redis.redis.default_database[0].primary_access_key
    secondary_access_key = azurerm_managed_redis.redis.default_database[0].secondary_access_key
  })

  lifecycle {
    precondition {
      condition     = var.access_keys_authentication_enabled
      error_message = "access_keys_authentication_enabled must be true when enable_vault_secret is true, otherwise access keys are empty."
    }
  }
}
