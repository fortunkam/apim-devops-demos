resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: 'bootcamp-apim-prod'
}

resource backend_dadjoke 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  name: 'ICanHazDadJoke'
  parent: apim
  properties: {
    description: 'ICanHazDadJoke'
    protocol: 'http'
    title: 'ICanHazDadJoke'
    url: 'https://icanhazdadjoke.com/'
  }
}

resource product_dadjoke 'Microsoft.ApiManagement/service/products@2021-08-01' = {
  name: 'DadJokeProduct'
  parent: apim
  properties: {
    approvalRequired: false
    description: 'DadJokeProduct'
    displayName: 'DadJokeProduct'
    state: 'Published'
    subscriptionRequired: true
  }
}

resource nv_pagelimit 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'DadJokePageLimit'
  parent: apim
  properties: {
    displayName: 'DadJokePageLimit'
    secret: false
    value: '10'
  }
}

resource api_dadjoke 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: 'dad-joke'
  parent: apim
  properties: {
    description: 'Dad-Joke-As-A-Service'
    displayName: 'Dad Joke'
    protocols: [
      'https'
    ]
    format: 'swagger-json'
    path: 'joke'
    value: loadTextContent('swagger.json')
  }
}

resource alloperations 'Microsoft.ApiManagement/service/apis/policies@2020-12-01' = {
  name: 'policy'
  parent: api_dadjoke
  properties: {
    format: 'rawxml'
    value: loadTextContent('policies/all_operations.policy.xml')
  }
}

resource operation_policy_get_random_joke 'Microsoft.ApiManagement/service/apis/operations/policies@2020-12-01' = {
  name: '${apim.name}/dad-joke/get-a-random-joke/policy'
  properties: {
    format: 'rawxml'
    value: loadTextContent('policies/get_random_joke.policy.xml')
  }
  dependsOn: [ 
    api_dadjoke 
  ]
}

resource operation_policy_get_joke 'Microsoft.ApiManagement/service/apis/operations/policies@2020-12-01' = {
  name: '${apim.name}/dad-joke/get-joke/policy'
  properties: {
    format: 'rawxml'
    value: loadTextContent('policies/get_joke.policy.xml')
  }
  dependsOn: [ 
    api_dadjoke 
  ]
}

resource operation_policy_search_for_jokes 'Microsoft.ApiManagement/service/apis/operations/policies@2020-12-01' = {
  name: '${apim.name}/dad-joke/search-for-jokes/policy'
  properties: {
    format: 'rawxml'
    value: loadTextContent('policies/search_jokes.policy.xml')
  }
  dependsOn: [ 
    api_dadjoke 
  ]
}

resource product_api_dadjoke 'Microsoft.ApiManagement/service/products/apis@2020-12-01' = {
  name: '${apim.name}/${product_dadjoke.name}/${api_dadjoke.name}'
}



