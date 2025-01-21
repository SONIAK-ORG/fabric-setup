terraform {
  required_version = ">= 0.12"
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "~> 1.0.0"  # Use the appropriate version from the registry
    }
  }
}