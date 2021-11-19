resource "azurerm_api_management_api" "dadjoke" {
  name                = "dad-joke"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Dad Joke"
  path                = "joke"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("swagger.json")
  }
}

resource "azurerm_api_management_api_policy" "dadjoke" {
  api_name            = azurerm_api_management_api.dadjoke.name
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="ICanHazDadJoke" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_api_operation_policy" "get-a-random-joke" {
  api_name            = azurerm_api_management_api.dadjoke.name
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  operation_id = "get-a-random-joke"

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <rewrite-uri template="/" copy-unmatched-params="false" />
        <set-header name="Accept" exists-action="override">
            <value>application/json</value>
        </set-header>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

# resource "azurerm_api_management_api_operation_tag" "get-a-random-joke-joke-tag" {
#   api_operation_id = "get-a-random-joke"
#   name             = azurerm_api_management_tag.joke.name
#   display_name     = azurerm_api_management_tag.joke.name
# }

resource "azurerm_api_management_api_operation_policy" "get-joke" {
  api_name            = azurerm_api_management_api.dadjoke.name
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  operation_id = "get-joke"

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <rewrite-uri template="/j/{id}" copy-unmatched-params="false" />
        <set-header name="Accept" exists-action="override">
            <value>application/json</value>
        </set-header>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}


resource "azurerm_api_management_api_operation_policy" "joke-search" {
  api_name            = azurerm_api_management_api.dadjoke.name
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  operation_id = "search-for-jokes"

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <rewrite-uri template="/search" copy-unmatched-params="false" />
        <set-header name="Accept" exists-action="override">
            <value>application/json</value>
        </set-header>
        <set-variable name="jsonBody" value="@{
            return context.Request.Body.As<JObject>();
        }" />
        <set-query-parameter name="page" exists-action="override">
            <value>@(((JObject)context.Variables["jsonBody"])["page"].ToString())</value>
        </set-query-parameter>
        <set-query-parameter name="term" exists-action="override">
            <value>@(((JObject)context.Variables["jsonBody"])["term"].ToString())</value>
        </set-query-parameter>
        <set-query-parameter name="limit" exists-action="override">
            <value>{{ DadJokePageLimit }}</value>
        </set-query-parameter>
        <set-method>GET</set-method>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_product_api" "dadjoke-product" {
  api_name            = azurerm_api_management_api.dadjoke.name
  product_id          = azurerm_api_management_product.dadjoke.product_id
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
}
