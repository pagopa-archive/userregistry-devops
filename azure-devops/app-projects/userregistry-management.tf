variable "userregistry-management" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "userregistry-management"
      branch_name     = "main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_deploy = true
    }
  }
}

locals {
  # global vars
  userregistry-management-variables = {
    dockerfile                       = "Dockerfile"
  }
  # global secrets
  userregistry-management-variables_secret = {

  }
  # code_review vars
  userregistry-management-variables_code_review = {

  }
  # code_review secrets
  userregistry-management-variables_secret_code_review = {

  }
  # deploy vars
  userregistry-management-variables_deploy = {
    image_repository_name               = replace(var.userregistry-management.repository.name, "-", "")
    # todo
    dev_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.selfcare-azurecr-dev.service_endpoint_name
    dev_azure_subscription              = azuredevops_serviceendpoint_kubernetes.DEV-USERREGISTRY.service_endpoint_name
    dev_container_registry_name         = "usrregdacr.azurecr.io"
    dev_agent_pool                      = "usrreg-dev-linux"
    dev_web_app_name                    = "usrreg-d-app"
    dev_web_app_resource_group_name     = "usrreg-d-app-rg"
    dev_deploy_type                     = "production_slot" # staging_slot_and_swap
  }
  # deploy secrets
  userregistry-management-variables_secret_deploy = {

  }
}

module "userregistry-management_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v1.0.0"
  count  = var.userregistry-management.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.userregistry-management.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.io-azure-devops-github-pr.id

  ci_trigger_use_yaml = true

  variables = merge(
    local.userregistry-management-variables,
    local.userregistry-management-variables_deploy,
  )

  variables_secret = merge(
    local.userregistry-management-variables_secret,
    local.userregistry-management-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.io-azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SELFCARE.id,
    //    azuredevops_serviceendpoint_azurerm.UAT-SELFCARE.id, TODO uncomment when aks UAT will be available
    //    azuredevops_serviceendpoint_azurerm.PROD-SELFCARE.id, TODO uncomment when aks PROD will be available
    azuredevops_serviceendpoint_azurecr.selfcare-azurecr-dev.id,
    azuredevops_serviceendpoint_kubernetes.selfcare-aks-dev.id,
    /* TODO uncomment when aks UAT will be available
    azuredevops_serviceendpoint_azurecr.selfcare-azurecr-uat.id,
    azuredevops_serviceendpoint_kubernetes.selfcare-aks-uat.id,*/
    /* TODO uncomment when aks PROD will be available
    azuredevops_serviceendpoint_azurecr.selfcare-azurecr-prod.id,
    azuredevops_serviceendpoint_kubernetes.selfcare-aks-prod.id,*/
  ]
}
