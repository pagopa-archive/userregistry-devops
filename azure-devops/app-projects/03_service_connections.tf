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
resource "azuredevops_serviceendpoint_azurerm" "DEV-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = format("%s-SERVICE-CONN", var.dev_subscription_name)
  description               = format("%s Service connection", var.dev_subscription_name)
  azurerm_subscription_name = var.dev_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

# UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = format("%s-SERVICE-CONN", var.uat_subscription_name)
  description               = format("%s Service connection", var.uat_subscription_name)
  azurerm_subscription_name = var.uat_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}

# PROD service connection
resource "azuredevops_serviceendpoint_azurerm" "PROD-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = format("%s-SERVICE-CONN", var.prod_subscription_name)
  description               = format("%s Service connection", var.prod_subscription_name)
  azurerm_subscription_name = var.prod_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
}

# DEV service connection for azure kubernetes service
resource "azuredevops_serviceendpoint_kubernetes" "aks-dev" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "usrreg-aks-dev"
  apiserver_url         = module.secrets.values["dev-usrreg-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets.values["dev-usrreg-aks-azure-devops-sa-token"].value
    ca_cert = module.secrets.values["dev-usrreg-aks-azure-devops-sa-cacrt"].value
  }
}
/*
# UAT service connection for azure kubernetes service
resource "azuredevops_serviceendpoint_kubernetes" "aks-uat" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "usrreg-aks-uat"
  apiserver_url         = module.secrets.values["uat-usrreg-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets.values["uat-usrreg-aks-azure-devops-sa-token"].value
    ca_cert = module.secrets.values["uat-usrreg-aks-azure-devops-sa-cacrt"].value
  }
}

# PROD service connection for azure kubernetes service
resource "azuredevops_serviceendpoint_kubernetes" "aks-prod" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "usrreg-aks-prod"
  apiserver_url         = module.secrets.values["prod-usrreg-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets.values["prod-usrreg-aks-azure-devops-sa-token"].value
    ca_cert = module.secrets.values["prod-usrreg-aks-azure-devops-sa-cacrt"].value
  }
}*/