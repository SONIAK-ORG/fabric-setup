# Example workspace resource configuration
resource "example_workspace_resource" "this" {
  for_each   = var.workspaces
  name       = each.value.name
  capacity_id = each.value.capacity_id
  location    = each.value.location
  tags        = each.value.tags
}
