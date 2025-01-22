locals {
  # Parse YAML file relative to this module
  config = yamldecode(file("${path.module}/variables.yaml"))

  # Safely extract capacities and workspaces maps, defaulting to empty maps if not found
  capacities = try(local.config.capacities, {})
  workspaces   = try(local.config.workspaces, {})
}

module "capacity" {
  source     = "./module/capacity"
  capacities = local.capacities

  # Explicitly pass providers if needed (optional)
  providers = {
    azapi   = azapi
    fabric  = fabric
  }
}

module "workspace" {
  source     = "./module/workspace"
  workspaces = local.workspaces

  # Explicitly pass providers if needed (optional)
  providers = {
    azurerm = azurerm
    azapi   = azapi
  }
}



