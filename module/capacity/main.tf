# Example capacity resource configuration
resource "example_capacity_resource" "this" {
  for_each = var.capacities
  name     = each.value.name
  sku_name = each.value.sku_name
  location = each.value.location
  tags     = each.value.tags
}
