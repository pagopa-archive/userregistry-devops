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

# DEV service connection
resource "azuredevops_serviceendpoint_azurerm" "DEV-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "DEV-SERVICE-CONN"
  description               = "DEV Service connection"
  azurerm_subscription_name = var.dev_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

# UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "UAT-SERVICE-CONN"
  description               = "UAT Service connection"
  azurerm_subscription_name = var.uat_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}

# PROD service connection
resource "azuredevops_serviceendpoint_azurerm" "PROD-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "PROD-SERVICE-CONN"
  description               = "PROD Service connection"
  azurerm_subscription_name = var.prod_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
}

#
# Permissions
#

# 🟢 DEV azure devops kv access policy
data "azuread_service_principal" "iac_principal_dev" {
  display_name = "${local.azure_devops_org}-${var.project_name_prefix}-iac-projects-${module.secrets.values["DEV-SUBSCRIPTION-ID"].value}"

  depends_on = [
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN
  ]
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_policy_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = data.azuread_service_principal.iac_principal_dev.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  certificate_permissions = ["Get", "List", "Update", "Create", ]
  storage_permissions     = []
}

# 🟨 UAT azure devops kv access policy
data "azuread_service_principal" "iac_principal_uat" {
  display_name = "${local.azure_devops_org}-${var.project_name_prefix}-iac-projects-${module.secrets.values["UAT-SUBSCRIPTION-ID"].value}"

  depends_on = [
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN
  ]
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_policy_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_uat.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = data.azuread_service_principal.iac_principal_uat.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  certificate_permissions = ["Get", "List", "Update", "Create", ]
  storage_permissions     = []
}

# 🛑 PROD azure devops kv access policy
data "azuread_service_principal" "iac_principal_prod" {
  display_name = "${local.azure_devops_org}-${var.project_name_prefix}-iac-projects-${module.secrets.values["PROD-SUBSCRIPTION-ID"].value}"

  depends_on = [
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN
  ]
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_policy_prod" {
  provider = azurerm.prod

  key_vault_id = data.azurerm_key_vault.kv_prod.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = data.azuread_service_principal.iac_principal_prod.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  certificate_permissions = ["Get", "List", "Update", "Create", ]
  storage_permissions     = []
}
