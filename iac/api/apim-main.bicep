@description('The name of the APIM instance')
param apimName string

@description('The environment to deploy to')
@allowed([
  'dev'
  'test'
  'prod'
])
param env string

@description('The location to deploy to')
param location string

@description('The name of the API Gateway')
param apiGatewayName string

resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: '${apimName}-${env}'
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherEmail: 'mrcndabrowski@gmail.com'
    publisherName: apiGatewayName
  }
}

resource apimGlobalPolicy 'Microsoft.ApiManagement/service/policies@2021-08-01' = {
  parent: apim
  name: 'policy'
  properties: {
    format: 'xml'
    value: loadTextContent('apim-policy.xml')
  }
}
