terraform {
  required_version = ">= 1.1.3, < 2.0.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.0"
    }

    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
