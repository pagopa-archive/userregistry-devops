# Github service connection (read-only)
resource "azuredevops_serviceendpoint_github" "azure-devops-github-ro" {
  depends_on = [azuredevops_project.project]

  project_id            = azuredevops_project.project.id
  service_endpoint_name = "azure-devops-github-ro"
  auth_personal {
    personal_access_token = module.secrets.values["azure-devops-github-ro-TOKEN"].value
  }
  lifecycle {
    ignore_changes = [description, authorization]
  }
}

# Github service connection (pull request)
resource "azuredevops_serviceendpoint_github" "azure-devops-github-pr" {
  depends_on = [azuredevops_project.project]

  project_id            = azuredevops_project.project.id
  service_endpoint_name = "azure-devops-github-pr"
  auth_personal {
    personal_access_token = module.secrets.values["azure-devops-github-pr-TOKEN"].value
  }
  lifecycle {
    ignore_changes = [description, authorization]
  }
}

# Github service connection (read-write)
resource "azuredevops_serviceendpoint_github" "azure-devops-github-rw" {
  depends_on = [azuredevops_project.project]

  project_id            = azuredevops_project.project.id
  service_endpoint_name = "azure-devops-github-rw"
  auth_personal {
    personal_access_token = module.secrets.values["azure-devops-github-rw-TOKEN"].value
  }
  lifecycle {
    ignore_changes = [description, authorization]
  }
}

# TODO azure devops terraform provider does not support SonarCloud service endpoint
locals {
  azuredevops_serviceendpoint_sonarcloud_id = "TODO: create sonar cloud id"
}

# DEV service connection
resource "azuredevops_serviceendpoint_azurerm" "DEV-USERREGISTRY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "DEV-USERREGISTRY-SERVICE-CONN"
  description               = "DEV-USERREGISTRY Service connection"
  azurerm_subscription_name = "DEV-USERREGISTRY"
  azurerm_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["PAGOPAIT-DEV-USERREGISTRY-SUBSCRIPTION-ID"].value
}

# UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-USERREGISTRY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "UAT-USERREGISTRY-SERVICE-CONN"
  description               = "UAT-USERREGISTRY Service connection"
  azurerm_subscription_name = "UAT-USERREGISTRY"
  azurerm_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["PAGOPAIT-UAT-USERREGISTRY-SUBSCRIPTION-ID"].value
}

# PROD service connection
resource "azuredevops_serviceendpoint_azurerm" "PROD-USERREGISTRY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "PROD-USERREGISTRY-SERVICE-CONN"
  description               = "PROD-USERREGISTRY Service connection"
  azurerm_subscription_name = "PROD-USERREGISTRY"
  azurerm_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["PAGOPAIT-PROD-USERREGISTRY-SUBSCRIPTION-ID"].value
}

#
# 🔐 Service connection 2 KV
#
module "DEV-USERREGISTRY-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.2"

  project_id        = azuredevops_project.project.id
  renew_token       = local.tlscert_renew_token
  name              = format("%s-d-tls-cert", local.prefix)
  tenant_id         = module.secrets.values["PAGOPAIT-TENANTID"].value
  subscription_id   = module.secrets.values["PAGOPAIT-DEV-USERREGISTRY-SUBSCRIPTION-ID"].value
  subscription_name = "DEV-USERREGISTRY"

  credential_subcription              = local.key_vault_subscription
  credential_key_vault_name           = local.key_vault_name
  credential_key_vault_resource_group = local.key_vault_resource_group
}

data "azurerm_key_vault" "kv_dev" {
  provider            = azurerm.dev
  name                = format("%s-d-kv", local.prefix)
  resource_group_name = format("%s-d-sec-rg", local.prefix)
}

resource "azurerm_key_vault_access_policy" "DEV-USERREGISTRY-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider     = azurerm.dev
  key_vault_id = data.azurerm_key_vault.kv_dev.id
  tenant_id    = module.secrets.values["PAGOPAIT-TENANTID"].value
  object_id    = module.DEV-USERREGISTRY-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

module "UAT-USERREGISTRY-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.2"

  project_id        = azuredevops_project.project.id
  renew_token       = local.tlscert_renew_token
  name              = format("%s-u-tls-cert", local.prefix)
  tenant_id         = module.secrets.values["PAGOPAIT-TENANTID"].value
  subscription_id   = module.secrets.values["PAGOPAIT-UAT-USERREGISTRY-SUBSCRIPTION-ID"].value
  subscription_name = "UAT-USERREGISTRY"

  credential_subcription              = local.key_vault_subscription
  credential_key_vault_name           = local.key_vault_name
  credential_key_vault_resource_group = local.key_vault_resource_group
}

data "azurerm_key_vault" "kv_uat" {
  provider            = azurerm.uat
  name                = format("%s-u-kv", local.prefix)
  resource_group_name = format("%s-u-sec-rg", local.prefix)
}

resource "azurerm_key_vault_access_policy" "UAT-USERREGISTRY-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.kv_uat.id
  tenant_id    = module.secrets.values["PAGOPAIT-TENANTID"].value
  object_id    = module.UAT-USERREGISTRY-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

module "PROD-USERREGISTRY-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.2"

  project_id        = azuredevops_project.project.id
  renew_token       = local.tlscert_renew_token
  name              = format("%s-p-tls-cert", local.prefix)
  tenant_id         = module.secrets.values["PAGOPAIT-TENANTID"].value
  subscription_id   = module.secrets.values["PAGOPAIT-PROD-USERREGISTRY-SUBSCRIPTION-ID"].value
  subscription_name = "PROD-USERREGISTRY"

  credential_subcription              = local.key_vault_subscription
  credential_key_vault_name           = local.key_vault_name
  credential_key_vault_resource_group = local.key_vault_resource_group
}

data "azurerm_key_vault" "kv_prod" {
  provider            = azurerm.prod
  name                = format("%s-p-kv", local.prefix)
  resource_group_name = format("%s-p-sec-rg", local.prefix)
}

resource "azurerm_key_vault_access_policy" "PROD-USERREGISTRY-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider     = azurerm.prod
  key_vault_id = data.azurerm_key_vault.kv_prod.id
  tenant_id    = module.secrets.values["PAGOPAIT-TENANTID"].value
  object_id    = module.PROD-USERREGISTRY-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}
