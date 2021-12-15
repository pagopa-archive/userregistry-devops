module "secrets_dev" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_key_vault_resource_group
  key_vault_name = local.dev_key_vault_name

  secrets = [
    "aks-apiserver-url",
    "aks-azure-devops-sa-cacrt",
    "aks-azure-devops-sa-token",
  ]
}

# 🟢 DEV service connection for azure kubernetes service
resource "azuredevops_serviceendpoint_kubernetes" "aks-dev" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "${local.prefix}-aks-dev"
  apiserver_url         = module.secrets_dev.values["aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets_dev.values["aks-azure-devops-sa-token"].value
    ca_cert = module.secrets_dev.values["aks-azure-devops-sa-cacrt"].value
  }
}
