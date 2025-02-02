@description('Location for the resources')
param location string

@description('Env, prod, test or dev')
@allowed([
  'prod'
  'test'
  'dev'
])
param env string

resource storageAccount 'Microsoft.Storage/storageAccounts@2031-05-01' = {
  name: 'filestorage-${env}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
} 
