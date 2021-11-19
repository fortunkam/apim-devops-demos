resource "azurerm_api_management_backend" "dadjoke" {
  name                = "ICanHazDadJoke"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  protocol            = "http"
  url                 = "https://icanhazdadjoke.com/"
}