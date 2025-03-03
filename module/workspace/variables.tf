variable "workspaces" {
  description = "Map of workspace definitions"
  type = map(object({
    display_name = string
    capacity_id  = string
  }))
  default = {}
}
