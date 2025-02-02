param location string
param prefix string

resource redis 'Microsoft.Cache/Redis@2020-06-01' = {
  name: '${prefix}-redis'
  location: location
  sku: {
    name: 'Basic'
    family: 'C'
    capacity: 0
  }
  properties: {
    enableNonSslPort: false
  }
} 
