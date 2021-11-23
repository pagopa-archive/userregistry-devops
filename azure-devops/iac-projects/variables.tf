variable dev_subscription_name {
  type        = string
  description = "DEV Subscription name"
}

variable uat_subscription_name {
  type        = string
  description = "UAT Subscription name"
}

variable prod_subscription_name {
  type        = string
  description = "PROD Subscription name"
}

variable project_name_prefix {
  type        = string
  description = "Project name prefix (e.g. userregistry)"
}

locals {
  prefix              = "usrreg"
  azure_devops_org    = "pagopaspa"
  github_org          = "pagopa"
  tlscert_renew_token = "v1"

  dev_key_vault_name            = format("%s-d-kv", local.prefix)
  uat_key_vault_name            = format("%s-u-kv", local.prefix)
  prod_key_vault_name           = format("%s-p-kv", local.prefix)

  dev_key_vault_resource_group  = format("%s-d-sec-rg", local.prefix)
  uat_key_vault_resource_group  = format("%s-u-sec-rg", local.prefix)
  prod_key_vault_resource_group = format("%s-p-sec-rg", local.prefix)


  #
  # IaC
  #
  iac-variables = {  }
  # global secrets
  iac-variables_secret = {  }

  # code_review vars
  iac-variables_code_review = {  }
  # code_review secrets
  iac-variables_secret_code_review = {  }

  # deploy vars
  iac-variables_deploy = {  }
  # deploy secrets
  iac-variables_secret_deploy = {  }
}
