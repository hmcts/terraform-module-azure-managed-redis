# only for use when building from ADO and as a quick example to get valid tags
# if you are building from Jenkins use `var.common_tags` provided by the pipeline
module "common_tags" {
  source = "github.com/hmcts/terraform-module-common-tags?ref=master"

  builtFrom   = "hmcts/terraform-module-azure-managed-redis"
  environment = "ptlsbox"
  product     = "sds-platform"
}
