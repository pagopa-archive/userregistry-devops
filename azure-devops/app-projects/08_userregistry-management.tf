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
    dev_replicas           = 1
    uat_replicas           = 1
    prod_replicas          = 1
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
    k8s_image_repository_name              = replace(var.userregistry-management.repository.name, "-", "")
    deploy_namespace                       = "usrreg"
    common_container_registry_name         = "ghcr.io"
    common_container_registry_service_conn = azuredevops_serviceendpoint_dockerregistry.github_docker_registry_ro.service_endpoint_name
    # 🟢 DEV
    dev_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.azurecr-dev.service_endpoint_name
    dev_kubernetes_service_conn         = azuredevops_serviceendpoint_kubernetes.aks-dev.service_endpoint_name
    dev_container_registry_name         = "${local.docker_registry_name_dev}.azurecr.io"
    dev_agent_pool                      = "${local.prefix}-dev-linux"
    # 🟨 UAT
    uat_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.azurecr-uat.service_endpoint_name
    uat_kubernetes_service_conn         = azuredevops_serviceendpoint_kubernetes.aks-uat.service_endpoint_name
    uat_container_registry_name         = "${local.docker_registry_name_uat}.azurecr.io"
    uat_agent_pool                      = "${local.prefix}-uat-linux"
    # 🛑 PROD
    prod_container_registry_service_conn    = azuredevops_serviceendpoint_azurecr.azurecr-prod.service_endpoint_name
    prod_kubernetes_service_conn            = azuredevops_serviceendpoint_kubernetes.aks-prod.service_endpoint_name
    prod_container_registry_name            = "${local.docker_registry_name_prod}.azurecr.io"
    prod_agent_pool                         = "${local.prefix}-prod-linux"
  }
  # deploy secrets
  userregistry-management-variables_secret_deploy = {

  }
}

#--------------------------------------------------------------------------------------------------

module "userregistry-management_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
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
    # 🟢 DEV
    azuredevops_serviceendpoint_azurecr.azurecr-dev.id,
    azuredevops_serviceendpoint_kubernetes.aks-dev.id,
    # 🟨 UAT
    azuredevops_serviceendpoint_kubernetes.aks-uat.id,
    azuredevops_serviceendpoint_azurecr.azurecr-uat.id,
    # 🛑 PROD
    azuredevops_serviceendpoint_kubernetes.aks-prod.id,
    azuredevops_serviceendpoint_azurecr.azurecr-prod.id,
  ]
}
