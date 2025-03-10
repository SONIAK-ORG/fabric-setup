terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi" # Ensure this matches the provider source in the root module
      version = "~> 2.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm" # Ensure this matches the provider source in the root module
      version = "~> 4.16.0"
    }
    fabric = {
      source  = "microsoft/fabric"
      version = "0.1.0-beta.7"
    }
  }

  backend "azurerm" {
   subscription_id = "903df39b-753b-4215-bad5-d8fbf346b48a"
  }
}

# AzureRM provider for authentication
provider "azurerm" {
  features {}

  use_oidc        = true
  use_cli         = false
}

# Microsoft Fabric provider configuration using OIDC authentication
provider "fabric" {
  use_oidc = true
  use_cli  = false
}

locals {
  # Instead of parsing a YAML file, use the workspaces variable provided via tfvars
  workspaces = var.workspaces
}

# Example workspace resource configuration
data "fabric_capacity" "fabric" {
  for_each     = local.workspaces
  display_name = each.value.capacity_id
}

resource "fabric_workspace" "this" {
  for_each    = local.workspaces
  display_name = each.value.display_name
  capacity_id  = data.fabric_capacity.fabric[each.key].id
