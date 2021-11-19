resource "azurerm_api_management_named_value" "dadjoke_pagelimit" {
  name                = "DadJokePageLimit"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "DadJokePageLimit"
  value               = "10"
}