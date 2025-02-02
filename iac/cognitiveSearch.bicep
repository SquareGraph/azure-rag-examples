param location string
param prefix string

resource searchService 'Microsoft.Search/searchServices@2020-08-01' = {
  name: '${prefix}-search'
  location: location
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
  }
} 
