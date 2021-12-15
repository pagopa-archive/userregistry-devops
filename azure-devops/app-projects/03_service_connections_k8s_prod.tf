module "secrets_prod" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.5"
  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_name

  secrets = [
    "aks-apiserver-url",
    "aks-azure-devops-sa-cacrt",
    "aks-azure-devops-sa-token",
  ]
}

# 🛑 PROD service connection for azure kubernetes service
resource "azuredevops_serviceendpoint_kubernetes" "aks-prod" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "${local.prefix}-aks-prod"
  apiserver_url         = module.secrets_prod.values["aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets_prod.values["aks-azure-devops-sa-token"].value
    ca_cert = module.secrets_prod.values["aks-azure-devops-sa-cacrt"].value
  }
}
