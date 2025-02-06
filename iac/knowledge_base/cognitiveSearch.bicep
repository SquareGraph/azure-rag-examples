@description('Location for the resources')
param location string

@description('Env, prod, test or dev')
@allowed([
  'prod'
  'test'
  'dev'
])
param env string

resource searchService 'Microsoft.Search/searchServices@2025-02-01-preview' = {
  name: 'search-${env}'
  location: location
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
  }
} 
