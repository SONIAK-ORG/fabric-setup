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
  }

  backend "azurerm" {
    use_oidc = true
  }
}


provider "azurerm" {
  features {}
  use_oidc = true
  use_cli = false
  subscription_id = "229f8a90-d75b-41db-ae79-90cdc72a0d11"
}

provider "azapi" {
  use_oidc = true
  use_cli  = false
}




locals {
  # Define constant admin members that should always be included
  default_admin_members = ["0e260fa0-f3a2-4018-809c-98a4f54ac315"]

  # Parse YAML file relative to this module
  config = yamldecode(file("${path.module}/../../variables.yaml"))

  # Safely extract capacities, defaulting to empty map
  capacities = try(local.config.capacities, {})
}

# Dynamically retrieve resource group IDs
data "azurerm_resource_group" "fab" {
  for_each = local.capacities
  name     = each.value.resource_group_name
}

resource "azapi_resource" "fab_capacity" {
  for_each = local.capacities

  type                      = "Microsoft.Fabric/capacities@2022-07-01-preview"
  name                      = each.value.display_name
  parent_id                 = data.azurerm_resource_group.fab[each.key].id
  location                  = each.value.location
  schema_validation_enabled = false

  body = {
    properties = {
      administration = {
        members = concat(local.default_admin_members, try(coalesce(each.value.administration.members, []), []))
      }
    }
    sku = {
      name = each.value.sku.name
      tier = each.value.sku.tier
    }
  }

  tags = each.value.tags
}
