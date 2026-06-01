# file consists of logic for managed identity creation and ACL assignment

locals {
  # Flatten policy assignments into a stable map keyed by "<policy-slug>/<label>".
  flattened_access_policy_assignments = {
    for assignment in flatten([
      for policy, principals in var.redis_access_policy_assignments : [
        for label, principal in principals : {
          key = "${replace(lower(policy), " ", "-")}/${label}"
          # display_name is auto-assembled from local.name + label + "-mi" unless explicitly overridden.
          display_name = coalesce(principal.display_name, "${local.name}-${replace(lower(policy), " ", "-")}-${label}-mi")
          object_id    = principal.object_id
          create       = principal.object_id == null
        }
      ]
    ]) : assignment.key => assignment
  }

}


resource "azurerm_user_assigned_identity" "redis_acl_mi" {
  # only creates this if requested in the tfvars
  for_each = {
    for key, assignment in local.flattened_access_policy_assignments :
    key => assignment if assignment.create
  }

  name                = each.value.display_name
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  tags                = local.merged_tags
}

resource "azurerm_managed_redis_access_policy_assignment" "redis_access_policy_assignments" {
  for_each = local.flattened_access_policy_assignments

  managed_redis_id = azurerm_managed_redis.redis.id

  # either creates assignment using one created above or provided objectID
  object_id = each.value.create ? azurerm_user_assigned_identity.redis_acl_mi[each.key].principal_id : each.value.object_id
}
