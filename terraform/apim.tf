data "azurerm_api_management" "apim" {
  name                = local.apimName
  resource_group_name = local.resource_group_name
}