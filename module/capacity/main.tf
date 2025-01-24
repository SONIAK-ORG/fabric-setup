
# Specify required providers
    
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

      
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.22.0" # Use the latest stable version
    }
  

  }
}






# Dynamically retrieve resource group IDs
data "azurerm_resource_group" "fab" {
  for_each = var.capacities
  name     = each.value.resource_group_name
}

resource "azapi_resource" "fab_capacity" {
  for_each = var.capacities

  type                      = "Microsoft.Fabric/capacities@2022-07-01-preview"
  name                      = each.value.name
  parent_id                 = data.azurerm_resource_group.fab[each.key].id
  location                  = each.value.location
  schema_validation_enabled = false

  body = {
    properties = {
      administration = {
        members = concat(each.value.administration.members, [data.azuread_service_principal.current.id])
      }
    }
    sku = {
      name = each.value.sku.name
      tier = each.value.sku.tier
    }
  }

  tags = each.value.tags
}

 