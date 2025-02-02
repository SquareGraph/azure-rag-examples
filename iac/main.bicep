targetScope = 'resourceGroup'

param location string = resourceGroup().location
param prefix string = 'ragapp'

module apimModule 'apim.bicep' = {
  name: '${prefix}-apimdeploy'
  params: {
    location: location
    prefix: prefix
    openAIPTUUrl: 'https://openai-ptu.example.com'  // placeholder URL—replace accordingly
    openAIPAYGUrl: 'https://openai-payg.example.com' // placeholder URL—replace accordingly
  }
}

module redisModule 'redis.bicep' = {
  name: '${prefix}-redisdeploy'
  params: {
    location: location
    prefix: prefix
  }
}

module eventGridModule 'eventGrid.bicep' = {
  name: '${prefix}-evtgdeploy'
  params: {
    location: location
    prefix: prefix
  }
}

module serviceBusModule 'serviceBus.bicep' = {
  name: '${prefix}-sbdeploy'
  params: {
    location: location
    prefix: prefix
  }
}

module funcHighModule 'azureFunctionHighPriority.bicep' = {
  name: '${prefix}-func-high-deploy'
  params: {
    location: location
    prefix: prefix
  }
}

module funcLowModule 'azureFunctionLowPriority.bicep' = {
  name: '${prefix}-func-low-deploy'
  params: {
    location: location
    prefix: prefix
  }
}

module cognitiveSearchModule 'cognitiveSearch.bicep' = {
  name: '${prefix}-searchdeploy'
  params: {
    location: location
    prefix: prefix
  }
}

module blobStorageModule 'blobStorage.bicep' = {
  name: '${prefix}-blobdeploy'
  params: {
    location: location
    prefix: prefix
  }
}

module cosmosModule 'cosmosDb.bicep' = {
  name: '${prefix}-cosmosdeploy'
  params: {
    location: location
    prefix: prefix
  }
}

module openaiModule 'openai.bicep' = {
  name: '${prefix}-openai-deploy'
  params: {
    location: location
    prefix: prefix
  }
} 
