terraform {
  required_version = ">= 1.8, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.2.0"
    }
    fabric = {
      source  = "microsoft/fabric"
      version = "0.1.0-beta.7"

    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-alz-mggmt-state-uksouth-001"
    storage_account_name = "stoalzmgguks001vnfd"
    container_name       = "fabric-tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Azure Resource Manager (azurerm) provider
provider "azurerm" {
  features {}

  subscription_id = "903df39b-753b-4215-bad5-d8fbf346b48a"
}

# Configure the AzAPI provider
provider "azapi" {
  # Optionally configure specific settings here
}

# Configure the Microsoft Fabric provider
provider "fabric" {
  # Optionally configure specific settings here
}