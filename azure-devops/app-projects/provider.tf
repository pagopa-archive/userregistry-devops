terraform {
  required_version = ">= 1.0.7"
  backend "azurerm" {
    resource_group_name  = "io-infra-rg"
    storage_account_name = "usrregpstinfraterraform"
    container_name       = "azuredevopsstate"
    key                  = "app-projects.terraform.tfstate"
  }
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "= 0.1.4"
    }
    azurerm = {
      version = "~> 2.52.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "prod"
  subscription_id = module.secrets.values["PAGOPAIT-PROD-PAGOPA-SUBSCRIPTION-ID"].value
}

provider "azurerm" {
  features {}
  alias           = "uat"
  subscription_id = module.secrets.values["PAGOPAIT-UAT-PAGOPA-SUBSCRIPTION-ID"].value
}


provider "azurerm" {
  features {}
  alias           = "dev"
  subscription_id = module.secrets.values["PAGOPAIT-DEV-PAGOPA-SUBSCRIPTION-ID"].value
}
