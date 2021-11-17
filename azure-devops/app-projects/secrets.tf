module "secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v1.0.11"

  resource_group = local.key_vault_resource_group
  key_vault_name = local.key_vault_name

  secrets = [
    "DANGER-GITHUB-API-TOKEN",
    "azure-devops-github-ro-TOKEN",
    "azure-devops-github-rw-TOKEN",
    "azure-devops-github-pr-TOKEN",
    "azure-devops-github-EMAIL",
    "azure-devops-github-USERNAME",
    "PAGOPAIT-TENANTID",
    "PAGOPAIT-DEV-USERREGISTRY-SUBSCRIPTION-ID",
    "PAGOPAIT-UAT-USERREGISTRY-SUBSCRIPTION-ID",
    "PAGOPAIT-PROD-USERREGISTRY-SUBSCRIPTION-ID",
  ]
}
