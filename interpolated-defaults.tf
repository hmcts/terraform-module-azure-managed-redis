locals {
  name = var.name != "" ? var.name : "${var.product}-${var.component}-${var.env}"

  resource_group_name     = var.existing_resource_group_name != null ? var.existing_resource_group_name : azurerm_resource_group.rg[0].name
  resource_group_location = var.existing_resource_group_name != null ? var.location : azurerm_resource_group.rg[0].location

  merged_tags       = merge(var.common_tags, var.tags)
  vault_environment = var.environment != "" ? var.environment : var.env
}
