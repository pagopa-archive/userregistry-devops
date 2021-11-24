# Github docker registry (read-only)
resource "azuredevops_serviceendpoint_dockerregistry" "github_docker_registry_ro" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "github-docker-registry-ro"
  docker_registry       = "https://ghcr.io"
  docker_username       = module.secrets.values["DOCKER-REGISTRY-PAGOPA-USER"].value
  docker_password       = module.secrets.values["DOCKER-REGISTRY-PAGOPA-TOKEN-RO"].value
  registry_type         = "Others"
}

# DEV service connection for azure container registry 
resource "azuredevops_serviceendpoint_azurecr" "azurecr-dev" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = format("%s-azurecr-dev", local.prefix)
  resource_group            = format("%s-d-app-rg", local.prefix)
  azurecr_name              = format("%sdacr", local.prefix)
  azurecr_subscription_name = var.dev_subscription_name
  azurecr_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurecr_subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}