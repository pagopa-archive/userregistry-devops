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
    dockerfile             = "Dockerfile"
    docker_base_image_name = "ghcr.io/pagopa/pdnd-interop-uservice-user-registry-management"
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
    image_repository_name                  = replace(var.userregistry-management.repository.name, "-", "")
    healthcheck_path                       = "/status"
    common_container_registry_name         = "ghcr.io"
    common_container_registry_service_conn = azuredevops_serviceendpoint_dockerregistry.github_docker_registry_ro.service_endpoint_name
    dev_container_registry_service_conn    = azuredevops_serviceendpoint_azurecr.azurecr-dev.service_endpoint_name
    dev_azure_subscription                 = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_container_registry_name            = format("%sdacr.azurecr.io", local.prefix)
    dev_agent_pool                         = format("%s-dev-linux", local.prefix)
    dev_web_app_name                       = format("%s-d-app", local.prefix)
    dev_web_app_resource_group_name        = format("%s-d-app-rg", local.prefix)
    dev_deploy_type                        = "production_slot" # staging_slot_and_swap
    # uat_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.azurecr-uat.service_endpoint_name
    # uat_azure_subscription              = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    # uat_container_registry_name         = format("%suacr.azurecr.io", local.prefix)
    # uat_agent_pool                      = format("%s-uat-linux", local.prefix)
    # uat_web_app_name                    = format("%s-u-app", local.prefix)
    # uat_web_app_resource_group_name     = format("%s-u-app-rg", local.prefix)
    # uat_deploy_type                     = "production_slot" # staging_slot_and_swap
    # prod_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.azurecr-prod.service_endpoint_name
    # prod_azure_subscription              = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
    # prod_container_registry_name         = format("%spacr.azurecr.io", local.prefix)
    # prod_agent_pool                      = format("%s-prod-linux", local.prefix)
    # prod_web_app_name                    = format("%s-p-app", local.prefix)
    # prod_web_app_resource_group_name     = format("%s-p-app-rg", local.prefix)
    # prod_deploy_type                     = "production_slot" # staging_slot_and_swap
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
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-ro.id

  ci_trigger_use_yaml = false

  variables = merge(
    local.userregistry-management-variables,
    local.userregistry-management-variables_deploy,
  )

  variables_secret = merge(
    local.userregistry-management-variables_secret,
    local.userregistry-management-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_dockerregistry.github_docker_registry_ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurecr.azurecr-dev.id,
  ]
}
