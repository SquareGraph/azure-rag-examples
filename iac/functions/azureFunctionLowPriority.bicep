@description('Location for the resources')
param location string

@description('Env, prod, test or dev')
@allowed([
  'prod'
  'test'
  'dev'
])
param env string

@description('Worker runtime')
@allowed([
  'dotnet'
  'dotnet-isolated'
  'java'
  'node'
  'python'
  'powershell'
  'custom'
])
param workerRuntime string

@description('Service Bus namespace name')
param sbNamespaceName string


resource functionPlanLow 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'func-plan-low-${env}'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionStorageLow 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'funcstoragelow-${env}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

var functionAppLowName = 'func-low-${env}'

resource functionAppLow 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppLowName
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
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorageLow.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionStorageLow.id, '2021-02-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppLowName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: workerRuntime
        }
        {
          name: 'ServiceBusConnection'
          value: 'Endpoint=sb://${sbNamespaceName}.servicebus.windows.net/;SharedAccessKeyName=${sbNamespaceName}-policy;SharedAccessKey=${sbNamespaceName}-policy-key'
        }
      ]
    }
  }
} 
