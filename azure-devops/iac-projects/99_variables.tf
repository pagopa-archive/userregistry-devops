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

#--------------------------------------------------------------------------------------------------

locals {
  prefix           = "usrreg"
  azure_devops_org = "pagopaspa"
  github_org       = "pagopa"

  #tfsec:ignore:GEN002
  tlscert_renew_token = "v1"
  github_infra_repo_name = "${var.project_name_prefix}-infra"

  # 🔐 KV
  dev_key_vault_name  = "${local.prefix}-d-kv-neu"
  uat_key_vault_name  = "${local.prefix}-u-kv-neu"
  prod_key_vault_name = "${local.prefix}-p-kv-weu"

  dev_key_vault_resource_group  = "${local.prefix}-d-sec-rg-neu"
  uat_key_vault_resource_group  = "${local.prefix}-u-sec-rg-neu"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg-weu"

  #
  # IaC
  #
  iac-variables = {}
  # global secrets
  iac-variables_secret = {}

  # code_review vars
  iac-variables_code_review = {}
  # code_review secrets
  iac-variables_secret_code_review = {}

  # deploy vars
  iac-variables_deploy = {}
  # deploy secrets
  iac-variables_secret_deploy = {}
}
