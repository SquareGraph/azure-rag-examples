@description('Location for the resources')
param location string

@description('Env, prod, test or dev')
@allowed([
  'prod'
  'test'
  'dev'
])
param env string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: toLower('filestoragemain${env}')
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
} 
