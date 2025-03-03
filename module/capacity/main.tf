terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16.0"
    }
  }

  backend "azurerm" {
    use_oidc = true
  }
}

provider "azurerm" {
  features        = {}
  use_oidc        = true
  use_cli         = false
  subscription_id = "229f8a90-d75b-41db-ae79-90cdc72a0d11"
}

provider "azapi" {
  use_oidc = true
  use_cli  = false
}

locals {
  default_admin_members = []
  capacities = var.capacities
  workspaces = var.workspaces
}

data "azurerm_resource_group" "fab" {
  for_each = local.capacities
  name     = each.value.resource_group_name
}

resource "azapi_resource" "fab_capacity" {
  for_each = local.capacities

  type                      = "Microsoft.Fabric/capacities@2022-07-01-preview"
  name                      = each.value.name
  parent_id                 = data.azurerm_resource_group.fab[each.key].id
  location                  = each.value.location
  schema_validation_enabled = false

  body = {
    properties = {
      administration = {
        members = concat(
          local.default_admin_members,
          try(coalesce(each.value.administration.members, []), [])
        )
      }
    }
    sku = {
      name = each.value.sku.name
      tier = each.value.sku.tier
    }
  }

  tags = each.value.tags
}

