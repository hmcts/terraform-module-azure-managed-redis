variable "env" {
  default     = "sbox"
  description = "Environment name, e.g. test, stg, prod"
}
variable "builtFrom" {
  description = "The source or origin of the build"
  default     = "hmcts/terraform-module-azure-managed-redis"
}

variable "product" {
  description = "The source or origin of the product"
  default     = "core"
}
