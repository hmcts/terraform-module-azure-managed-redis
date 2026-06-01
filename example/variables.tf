variable "env" {
  default     = "sandbox"
  description = "Environment name, e.g. test, stg, prod"
}
variable "builtFrom" {
  description = "The source or origin of the build"
  default     = "hmcts/terraform-module-azure-managed-redis"
}

variable "product" {
  description = "The source or origin of the product"
}

variable "redis_access_policy_assignments" {
  description = "Map of access policy name to a map of principals to assign."
  type = map(map(object({
    object_id    = optional(string)
    display_name = optional(string)
  })))
  default = {}
}
