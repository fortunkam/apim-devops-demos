terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.85.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  apimName = "bootcamp-apim-prod"
  resource_group_name = "apim-demo"
}