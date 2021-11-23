variable "dev_subscription_name" {
  type        = string
  description = "DEV Subscription name"
}

variable "uat_subscription_name" {
  type        = string
  description = "UAT Subscription name"
}

variable "prod_subscription_name" {
  type        = string
  description = "PROD Subscription name"
}

variable "project_name_prefix" {
  type        = string
  description = "Project name prefix (e.g. userregistry)"
}

locals {
  prefix           = "usrreg"
  azure_devops_org = "pagopaspa"

  dev_key_vault_name  = format("%s-d-kv", local.prefix)
  uat_key_vault_name  = format("%s-u-kv", local.prefix)
  prod_key_vault_name = format("%s-p-kv", local.prefix)

  dev_key_vault_resource_group  = format("%s-d-sec-rg", local.prefix)
  uat_key_vault_resource_group  = format("%s-u-sec-rg", local.prefix)
  prod_key_vault_resource_group = format("%s-p-sec-rg", local.prefix)

  dev_vnet_rg  = format("%s-d-vnet-rg", local.prefix)
  uat_vnet_rg  = format("%s-u-vnet-rg", local.prefix)
  prod_vnet_rg = format("%s-p-vnet-rg", local.prefix)

  tlscert_renew_token = "v1"
}
