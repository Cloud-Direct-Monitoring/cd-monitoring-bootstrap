terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id     = var.customer_subscription_id
  storage_use_azuread = true
}

provider "github" {
  owner = var.cd_github_org_name
  token = var.cd_github_pat_value
}
