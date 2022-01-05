#
# 🔐 KV
#
data "azurerm_key_vault" "kv_dev" {
  provider = azurerm.dev

  name                = local.dev_key_vault_name
  resource_group_name = local.dev_key_vault_resource_group
}

data "azurerm_key_vault" "kv_uat" {
  provider = azurerm.uat

  name                = local.uat_key_vault_name
  resource_group_name = local.uat_key_vault_resource_group
}

data "azurerm_key_vault" "kv_prod" {
  provider = azurerm.prod

  name                = local.prod_key_vault_name
  resource_group_name = local.prod_key_vault_resource_group
}
