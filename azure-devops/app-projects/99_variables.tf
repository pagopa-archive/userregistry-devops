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

  # 🔐 KV
  dev_key_vault_name  = format("%s-d-kv-neu", local.prefix)
  uat_key_vault_name  = format("%s-u-kv-neu", local.prefix)
  prod_key_vault_name = format("%s-p-kv-weu", local.prefix)

  dev_key_vault_resource_group  = format("%s-d-sec-rg-neu", local.prefix)
  uat_key_vault_resource_group  = format("%s-u-sec-rg-neu", local.prefix)
  prod_key_vault_resource_group = format("%s-p-sec-rg-weu", local.prefix)

  # ☁️ VNET
  dev_vnet_rg  = format("%s-d-vnet-rg", local.prefix)
  uat_vnet_rg  = format("%s-u-vnet-rg", local.prefix)
  prod_vnet_rg = format("%s-p-vnet-rg", local.prefix)

  # 📦 ACR DEV DOCKER
  srv_endpoint_docker_registry_dev = "${local.prefix}-azurecr-dev"
  docker_registry_rg_name_dev      = "${local.prefix}-d-docker-rg"
  docker_registry_name_dev         = "${local.prefix}dacr"

  # 📦 ACR UAT DOCKER
  srv_endpoint_docker_registry_uat = "${local.prefix}-azurecr-uat"
  docker_registry_rg_name_uat      = "${local.prefix}-u-docker-rg"
  docker_registry_name_uat         = "${local.prefix}uacr"

  # 📦 ACR PROD DOCKER
  srv_endpoint_docker_registry_prod = "${local.prefix}-azurecr-prod"
  docker_registry_rg_name_prod      = "${local.prefix}-p-docker-rg"
  docker_registry_name_prod         = "${local.prefix}pacr"

  #tfsec:ignore:GEN003
  #tfsec:ignore:GEN002
  tlscert_renew_token = "v1"
}
