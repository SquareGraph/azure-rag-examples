param location string
param prefix string
param openAIPTUUrl string
param openAIPAYGUrl string

resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: '${prefix}-apim'
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherEmail: 'admin@example.com'
    publisherName: prefix
  }
}

resource apimGlobalPolicy 'Microsoft.ApiManagement/service/policies@2021-08-01' = {
  name: '${apim.name}/policy'
  properties: {
    policyContent: loadTextContent('apim-policy.xml')
  }
}

resource apimBackendPTU 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  name: '${apim.name}/openai-ptu'
  properties: {
    url: openAIPTUUrl
    protocol: 'http'
  }
}

resource apimBackendPAYG 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  name: '${apim.name}/openai-payg'
  properties: {
    url: openAIPAYGUrl
    protocol: 'http'
  }
} 
