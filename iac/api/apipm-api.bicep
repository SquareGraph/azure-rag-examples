@description('The name of the APIM instance')
param apimName string

@description('The environment to deploy to')
@allowed([
  'dev'
  'test'
  'prod'
])
param env string

@description('The name of the API Gateway')
param apiGatewayName string

var openAISchemas = {
  prod: loadTextContent('open_api_definition/openai-schema-prod.json')
  test: loadTextContent('open_api_definition/openai-schema-dev.json')
  dev: loadTextContent('open_api_definition/openai-schema-dev.json')
}

var handlerSchemas = {
  prod: loadTextContent('open_api_definition/handler-schema-prod.json')
  test: loadTextContent('open_api_definition/handler-schema-dev.json')
  dev: loadTextContent('open_api_definition/handler-schema-dev.json')
}

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimName
}

resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  parent: apim
  name: '${apiGatewayName}-handler-${env}'
  properties: {
    displayName: 'Request Handler'
    path: '${env}/handler'
    protocols: [
      'https'
      'wss'
    ]
    subscriptionRequired: false
    format: 'openapi+json'
    value: handlerSchemas[env]
  }
}

resource apiOpenAI 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  parent: apim
  name: '${apiGatewayName}-openai-${env}'
  properties: {
    displayName: 'OpenAI API'
    path: '${env}/openai'
    protocols: [
      'https'
    ]
    subscriptionRequired: false
    format: 'openapi+json'
    value: openAISchemas[env]
  }
}
