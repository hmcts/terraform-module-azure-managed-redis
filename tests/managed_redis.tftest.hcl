# Tests for the Azure Managed Redis module

provider "azurerm" {
  features {}
  subscription_id = "64b1c6d6-1481-44ad-b620-d8fe26a2c768"
}

# Default variables for this test
variables {
  env       = "sandbox"
  product   = "myapp"
  component = "cache"
  project   = "sds"
}

run "setup" {
  module {
    source = "./tests/modules/setup"
  }
}

run "managed_redis_plan" {

  command = plan

  variables {
    common_tags = run.setup.common_tags
    sku_name    = "Balanced_B3"
    location    = "UK South"

    high_availability_enabled          = true
    public_network_access              = "Disabled"
    access_keys_authentication_enabled = false
    client_protocol                    = "Encrypted"
    clustering_policy                  = "OSSCluster"
    eviction_policy                    = "VolatileLRU"
  }

  assert {
    condition     = azurerm_managed_redis.redis.name == "myapp-cache-sandbox"
    error_message = "Redis instance name does not match expected value"
  }

  assert {
    condition     = azurerm_managed_redis.redis.sku_name == "Balanced_B3"
    error_message = "SKU name does not match expected value"
  }

  assert {
    condition     = azurerm_managed_redis.redis.location == "uksouth"
    error_message = "Location does not match expected value"
  }

  assert {
    condition     = azurerm_managed_redis.redis.high_availability_enabled == true
    error_message = "High availability should be enabled"
  }

  assert {
    condition     = azurerm_managed_redis.redis.public_network_access == "Disabled"
    error_message = "Public network access should be Disabled"
  }

  assert {
    condition     = azurerm_managed_redis.redis.default_database[0].client_protocol == "Encrypted"
    error_message = "Client protocol should be Encrypted"
  }

  assert {
    condition     = azurerm_managed_redis.redis.default_database[0].clustering_policy == "OSSCluster"
    error_message = "Clustering policy should be OSSCluster"
  }

  assert {
    condition     = azurerm_managed_redis.redis.default_database[0].eviction_policy == "VolatileLRU"
    error_message = "Eviction policy should be VolatileLRU"
  }
}

run "managed_redis_custom_name" {

  command = plan

  variables {
    name        = "custom-redis"
    common_tags = run.setup.common_tags
    sku_name    = "Balanced_B3"
  }

  assert {
    condition     = azurerm_managed_redis.redis.name == "custom-redis-sandbox"
    error_message = "Redis instance name does not match custom name"
  }
}

run "managed_redis_resource_group" {

  command = plan

  variables {
    common_tags = run.setup.common_tags
    sku_name    = "Balanced_B3"
  }

  assert {
    condition     = azurerm_resource_group.rg[0].name == "myapp-cache-sandbox-rg"
    error_message = "Resource group name does not match expected value"
  }

  assert {
    condition     = azurerm_resource_group.rg[0].location == "uksouth"
    error_message = "Resource group location should be UK South"
  }
}
