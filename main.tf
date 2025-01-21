locals {
  # Parse YAML file relative to this module
  config = yamldecode(file("${path.module}/variables.yaml"))

  # Safely extract capacities and workspaces maps, defaulting to empty maps if not found
  capacities = try(local.config.capacities, {})
  workspaces   = try(local.config.workspaces, {})
}

module "capacity" {
  source     = "./modules/capacity"
  capacities = local.capacities
}

module "workspace" {
  source     = "./modules/workspace"
  workspaces = local.workspaces
}
