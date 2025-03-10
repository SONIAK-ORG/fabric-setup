variable "capacities" {
  description = "Map of capacity definitions"
  type = map(object({
    sku = object({
      tier = string
      name = string
    })
    resource_group_name = string
    tags                = map(string)
    administration = object({
      members = list(string)
    })
    name     = string
    location = string
  }))
}

variable "workspaces" {
  description = "Map of workspace definitions"
  type = map(object({
    display_name = string
    capacity_id  = string
  }))
  default = {}
}
