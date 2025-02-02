@description('The name of the APIM instance')
param apimName string

@description('The environment to deploy to')
@allowed([
  'dev'
  'test'
  'prod'
])
param env string

@description('The URL for the PTU backend')
param openAIPTUUrl string

@description('The URL for the PAYG backend')
param openAIPAYGUrl string

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimName
}

// Backend resources for load balancing OpenAI calls
// PTU backend
resource apimBackendPTU 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  parent: apim
  name: 'openai-ptu'
  properties: {
    url: openAIPTUUrl
    protocol: 'http'
  }
}

// PAYG backend
resource apimBackendPAYG 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  parent: apim
  name: 'openai-payg'
  properties: {
    url: openAIPAYGUrl
    protocol: 'http'
  }
} 
