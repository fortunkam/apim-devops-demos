resource "azurerm_api_management_tag" "joke" {
  api_management_id = data.azurerm_api_management.apim.id
  name              = "Joke"
}

resource "azurerm_api_management_tag" "search" {
  api_management_id = data.azurerm_api_management.apim.id
  name              = "Search"
}