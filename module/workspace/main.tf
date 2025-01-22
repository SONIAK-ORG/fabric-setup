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
}

# Example workspace resource configuration
data "fabric_capacity" "fabric" {
  for_each     = var.workspaces
  display_name = each.value.capacity_id
}

resource "fabric_workspace" "this" {
  for_each   = var.workspaces

  display_name =  each.value.name
  capacity_id = data.fabric_capacity.fabric[each.key].id
}
