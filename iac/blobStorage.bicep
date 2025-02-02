param location string
param prefix string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: toLower('${prefix}filestorage')
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
} 
