resource "azurerm_api_management_product" "dadjoke" {
  product_id            = "DadJokeProduct"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name          = "DadJokeProduct"
  subscription_required = true
  approval_required     = false
  published             = true
}