variable dev_subscription_name {
  type        = string
  description = "DEV Subscription name"
}

variable uat_subscription_name {
  type        = string
  description = "UAT Subscription name"
}

variable prod_subscription_name {
  type        = string
  description = "PROD Subscription name"
}

locals {
  prefix                   = "usrreg"

  dev_key_vault_name            = format("%s-d-kv", local.prefix)
  uat_key_vault_name            = format("%s-u-kv", local.prefix)
  prod_key_vault_name           = format("%s-p-kv", local.prefix)

  dev_key_vault_resource_group  = format("%s-d-sec-rg", local.prefix)
  uat_key_vault_resource_group  = format("%s-u-sec-rg", local.prefix)
  prod_key_vault_resource_group = format("%s-p-sec-rg", local.prefix)

  tlscert_renew_token      = "v1"
}
