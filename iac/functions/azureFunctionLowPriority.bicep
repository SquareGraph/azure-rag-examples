param location string
param prefix string
param sbNamespaceName string

resource functionPlanLow 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: '${prefix}-func-plan-low'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionStorageLow 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: toLower('${prefix}funcstoragelow')
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource functionAppLow 'Microsoft.Web/sites@2021-03-01' = {
  name: '${prefix}-func-low'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: functionPlanLow.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorageLow.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionStorageLow.id, '2021-02-01').keys[0].value}'
        }
        {
          name: 'ServiceBusConnection'
          value: 'Endpoint=sb://${sbNamespaceName}.servicebus.windows.net/;SharedAccessKeyName=${sbNamespaceName}-policy;SharedAccessKey=${sbNamespaceName}-policy-key'
        }
      ]
    }
  }
} 
