param location string
param prefix string

resource functionPlanHigh 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: '${prefix}-func-plan-high'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionStorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: toLower('${prefix}funcstorage')
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource functionAppHigh 'Microsoft.Web/sites@2021-03-01' = {
  name: '${prefix}-func-high'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: functionPlanHigh.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: listKeys(functionStorage, '2021-02-01').keys[0].value
        }
      ]
    }
  }
} 
