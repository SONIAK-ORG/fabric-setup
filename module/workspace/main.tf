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

  backend "azurerm" {}
}

# AzureRM provider for authentication
provider "azurerm" {
  features {}

  use_oidc        = true
  use_cli         = false
  subscription_id = "229f8a90-d75b-41db-ae79-90cdc72a0d11"
}

# Microsoft Fabric provider configuration using OIDC authentication
provider "fabric" {
  use_oidc = true
  use_cli  = false
}

locals {
  # Parse YAML file relative to this module
  config = yamldecode(file("${path.module}/../../variables.yaml"))

  # Safely extract capacities and workspaces maps, defaulting to empty maps if not found
  workspaces = try(local.config.workspaces, {})
}

# Example workspace resource configuration
data "fabric_capacity" "fabric" {
  for_each     = local.workspaces
  display_name = each.value.capacity_id
}

resource "fabric_workspace" "this" {
  for_each    = local.workspaces
  display_name = each.value.name
  capacity_id  = data.fabric_capacity.fabric[each.key].id
}

