resource "azurerm_resource_group" "rg" {
  count = var.existing_resource_group_name == null ? 1 : 0

  name     = "${local.name}-${var.env}-rg"
  location = var.location

  tags = local.merged_tags
}
