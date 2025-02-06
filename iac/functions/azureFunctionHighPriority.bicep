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

resource functionPlanHigh 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'func-plan-high-${env}'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionStorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'funcstorage-${env}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

var functionAppName = 'func-high-${env}'

resource functionAppHigh 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: functionPlanHigh.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionStorage.id, '2021-02-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionStorage.id, '2021-02-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: workerRuntime
        }
      ]
    }
  }
} 

output functionAppHighId string = functionAppHigh.id
output functionAppHostName string = functionAppHigh.properties.defaultHostName
