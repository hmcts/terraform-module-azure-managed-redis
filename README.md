# terraform-module-azure-managed-redis

Terraform module for [Azure Managed Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/managed-redis/managed-redis-overview).

## Example

```hcl
module "managed_redis" {
  source = "git@github.com:hmcts/terraform-module-azure-managed-redis?ref=main"
  ...
}
```

## Deploying the Example

You can deploy the example resource using this module to the CNP `DTS-SHAREDSERVICESPTL-SBOX` subscription via the Azure DevOps pipeline.

To run the pipeline:

1. Navigate to the pipeline in Azure DevOps.
2. Click **Run pipeline**.
3. Tick the **`deploy_example`** checkbox.
4. Select the desired **`overrideAction`** (`plan`, `apply`, or `destroy`).
5. Click **Run**.

The pipeline will deploy the resources defined in the [example/](example/) directory to the sandbox subscription.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_managed_redis.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_redis) | resource |
| [azurerm_monitor_diagnostic_setting.redis_diag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_private_endpoint.redis_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [vault_generic_secret.managed_redis_access_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_keys_authentication_enabled"></a> [access\_keys\_authentication\_enabled](#input\_access\_keys\_authentication\_enabled) | Whether access key authentication is enabled for the database. Defaults to false (EntraID/RBAC auth only). | `bool` | `false` | no |
| <a name="input_client_protocol"></a> [client\_protocol](#input\_client\_protocol) | Whether redis clients connect using TLS-encrypted or plaintext protocols. Possible values: Encrypted, Plaintext. | `string` | `"Encrypted"` | no |
| <a name="input_clustering_policy"></a> [clustering\_policy](#input\_clustering\_policy) | Clustering policy. Possible values: EnterpriseCluster, OSSCluster, NoCluster. Changing this forces database recreation. | `string` | `"OSSCluster"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | https://hmcts.github.io/glossary/#component | `string` | n/a | yes |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | Customer-managed key configuration for at-rest encryption. Requires identity\_type to include UserAssigned. | <pre>object({<br/>    key_vault_key_id          = string<br/>    user_assigned_identity_id = string<br/>  })</pre> | `null` | no |
| <a name="input_diagnostic_eventhub_authorization_rule_id"></a> [diagnostic\_eventhub\_authorization\_rule\_id](#input\_diagnostic\_eventhub\_authorization\_rule\_id) | ID of the Event Hub Namespace Authorization Rule to send diagnostics to. Required if diagnostic\_eventhub\_name is set. | `string` | `null` | no |
| <a name="input_diagnostic_eventhub_name"></a> [diagnostic\_eventhub\_name](#input\_diagnostic\_eventhub\_name) | Name of the Event Hub to send diagnostics to. Optional. | `string` | `null` | no |
| <a name="input_diagnostic_log_categories"></a> [diagnostic\_log\_categories](#input\_diagnostic\_log\_categories) | List of log categories to enable. Set to null to use the provider default (all categories). Example: ["ConnectedClientList"]. | `list(string)` | `null` | no |
| <a name="input_diagnostic_metric_categories"></a> [diagnostic\_metric\_categories](#input\_diagnostic\_metric\_categories) | List of metric categories to enable. Set to null to use the provider default (all categories). Example: ["AllMetrics"]. | `list(string)` | `null` | no |
| <a name="input_diagnostic_settings_name"></a> [diagnostic\_settings\_name](#input\_diagnostic\_settings\_name) | Name of the diagnostic setting. Defaults to '<name>-<env>-diag'. | `string` | `""` | no |
| <a name="input_diagnostic_storage_account_id"></a> [diagnostic\_storage\_account\_id](#input\_diagnostic\_storage\_account\_id) | ID of the Storage Account to send diagnostics to. Optional. | `string` | `null` | no |
| <a name="input_enable_diagnostic_settings"></a> [enable\_diagnostic\_settings](#input\_enable\_diagnostic\_settings) | Whether to create a diagnostic setting for the Managed Redis instance. | `bool` | `false` | no |
| <a name="input_enable_vault_secret"></a> [enable\_vault\_secret](#input\_enable\_vault\_secret) | When true, the primary and secondary access keys are written to HashiCorp Vault at secret/terraform/<environment>/managedredis/<name>. Requires access\_keys\_authentication\_enabled = true. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name used in the Vault secret path (e.g. dev, staging, production). Defaults to the value of var.env if not set. Kept for compatibility with cpp-module-terraform-azurerm-redis. | `string` | `""` | no |
| <a name="input_eviction_policy"></a> [eviction\_policy](#input\_eviction\_policy) | Redis eviction policy. Possible values: AllKeysLFU, AllKeysLRU, AllKeysRandom, VolatileLRU, VolatileLFU, VolatileTTL, VolatileRandom, NoEviction. | `string` | `"VolatileLRU"` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_geo_replication_group_name"></a> [geo\_replication\_group\_name](#input\_geo\_replication\_group\_name) | Name of the geo-replication group. If set, links the database into an active geo-replication group. Cannot be combined with persistence settings. Changing this forces database recreation. | `string` | `null` | no |
| <a name="input_high_availability_enabled"></a> [high\_availability\_enabled](#input\_high\_availability\_enabled) | Whether to enable high availability for the Managed Redis instance. Defaults to true. Changing this forces a new resource. | `bool` | `true` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of User Assigned Managed Identity IDs. Required when identity\_type includes UserAssigned. | `list(string)` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of managed identity to assign. Possible values: SystemAssigned, UserAssigned, 'SystemAssigned, UserAssigned'. Leave null to omit identity. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | ID of the Log Analytics Workspace to send diagnostics to. Required when enable\_diagnostic\_settings is true. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be product+component+env, you can override the product+component part by setting this | `string` | `""` | no |
| <a name="input_persistence_aof_backup_frequency"></a> [persistence\_aof\_backup\_frequency](#input\_persistence\_aof\_backup\_frequency) | Frequency of Append Only File (AOF) backups. The only valid value is '1s'. Conflicts with persistence\_rdb\_backup\_frequency and geo\_replication\_group\_name. | `string` | `null` | no |
| <a name="input_persistence_rdb_backup_frequency"></a> [persistence\_rdb\_backup\_frequency](#input\_persistence\_rdb\_backup\_frequency) | Frequency of Redis Database (RDB) backups. Possible values: 1h, 6h, 12h. Conflicts with persistence\_aof\_backup\_frequency and geo\_replication\_group\_name. | `string` | `null` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | List of private DNS zone IDs to associate with the private endpoint. Typically the zone for privatelink.redisenterprise.cache.azure.net. | `list(string)` | `[]` | no |
| <a name="input_product"></a> [product](#input\_product) | https://hmcts.github.io/glossary/#product | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name - sds or cft. | `string` | n/a | yes |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Public network access setting. Possible values are Enabled and Disabled. | `string` | `"Disabled"` | no |
| <a name="input_redis_modules"></a> [redis\_modules](#input\_redis\_modules) | List of Redis modules to enable. Each entry must have a 'name' key. Optional 'args' key for module configuration. Possible names: RedisBloom, RedisTimeSeries, RediSearch, RedisJSON. Changing this forces database recreation. | <pre>list(object({<br/>    name = string<br/>    args = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU for the Managed Redis instance.<br/>Format is <Tier>\_<Size>, e.g. Balanced\_B3, ComputeOptimized\_X5.<br/>Tiers: Balanced (B), ComputeOptimized (X), FlashOptimized (A), MemoryOptimized (M).<br/>Sizes: B0/B1/B3/B5/B10/B20/B50/B100/B150/B250/B350/B500/B700/B1000,<br/>       X3/X5/X10/X20/X50/X100/X150/X250/X350/X500/X700,<br/>       A250/A500/A700/A1000/A1500/A2000/A4500,<br/>       M10/M20/M50/M100/M150/M250/M350/M500/M700/M1000/M1500/M2000. | `string` | `"Balanced_B3"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet used to create a private endpoint for the Managed Redis instance. Required when public\_network\_access is Disabled. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to merge with common\_tags. Provided for compatibility with cpp-module-terraform-azurerm-redis which uses 'tags' instead of 'common\_tags'. | `map(string)` | `{}` | no |
| <a name="input_vault_secret_path_prefix"></a> [vault\_secret\_path\_prefix](#input\_vault\_secret\_path\_prefix) | Path prefix used when writing secrets to Vault. Defaults to 'secret/terraform'. | `string` | `"secret/terraform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_database_id"></a> [default\_database\_id](#output\_default\_database\_id) | The ID of the Managed Redis default database. |
| <a name="output_diagnostic_setting_id"></a> [diagnostic\_setting\_id](#output\_diagnostic\_setting\_id) | The ID of the diagnostic setting, if created. |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The DNS hostname of the Managed Redis cluster endpoint. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Managed Redis instance. |
| <a name="output_port"></a> [port](#output\_port) | The TCP port of the database endpoint. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The primary access key for the Managed Redis database. Only populated when access\_keys\_authentication\_enabled is true. |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | The ID of the private endpoint, if created. |
| <a name="output_private_endpoint_ip_address"></a> [private\_endpoint\_ip\_address](#output\_private\_endpoint\_ip\_address) | The private IP address of the private endpoint, if created. |
| <a name="output_redis_cache_hostname"></a> [redis\_cache\_hostname](#output\_redis\_cache\_hostname) | Alias for hostname — backward compatible with cpp-module-terraform-azurerm-redis. |
| <a name="output_redis_cache_instance_id"></a> [redis\_cache\_instance\_id](#output\_redis\_cache\_instance\_id) | Alias for id — backward compatible with cpp-module-terraform-azurerm-redis. |
| <a name="output_redis_cache_primary_access_key"></a> [redis\_cache\_primary\_access\_key](#output\_redis\_cache\_primary\_access\_key) | Alias for primary\_access\_key — backward compatible with cpp-module-terraform-azurerm-redis. |
| <a name="output_redis_cache_primary_connection_string"></a> [redis\_cache\_primary\_connection\_string](#output\_redis\_cache\_primary\_connection\_string) | Constructed primary connection string in the format <hostname>:<port>,password=<key>,ssl=True. Only populated when access\_keys\_authentication\_enabled is true. |
| <a name="output_redis_cache_secondary_access_key"></a> [redis\_cache\_secondary\_access\_key](#output\_redis\_cache\_secondary\_access\_key) | Alias for secondary\_access\_key — backward compatible with cpp-module-terraform-azurerm-redis. |
| <a name="output_redis_cache_secondary_connection_string"></a> [redis\_cache\_secondary\_connection\_string](#output\_redis\_cache\_secondary\_connection\_string) | Constructed secondary connection string in the format <hostname>:<port>,password=<key>,ssl=True. Only populated when access\_keys\_authentication\_enabled is true. |
| <a name="output_redis_cache_ssl_port"></a> [redis\_cache\_ssl\_port](#output\_redis\_cache\_ssl\_port) | Alias for port — Managed Redis uses a single TLS port. Backward compatible with cpp-module-terraform-azurerm-redis. |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The Azure region of the resource group. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group containing the Managed Redis instance. |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | The secondary access key for the Managed Redis database. Only populated when access\_keys\_authentication\_enabled is true. |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
