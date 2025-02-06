targetScope = 'resourceGroup'

param location string = resourceGroup().location
param prefix string = 'ragapp'
param env string = 'dev'

// APIM related parameters
param apimName string = '${prefix}-apim'
param apiGatewayName string = '${prefix}-api-gateway'
param openAIPTUUrl string = 'https://openai-ptu.example.com' 
param openAIPAYGUrl string = 'https://openai-payg.example.com'

// Cosmos DB related parameters
param cosmosAccountName string = '${prefix}cosmos'
param primaryRegion string = location
param secondaryRegion string = location
param defaultConsistencyLevel string = 'Session'
param maxStalenessPrefix int = 100000
param maxIntervalInSeconds int = 300
param systemManagedFailover bool = true
param databaseName string = 'mydb'
param containerName string = 'mycontainer'
param autoscaleMaxThroughput int = 4000

// Service Bus parameter
param sbNamespaceName string = '${prefix}sb'

// Worker runtime for Functions (using python as example)
param workerRuntime string = 'python'

// Deploy the main APIM instance
module apimMainModule './iac/api/apim-main.bicep' = {
  name: '${prefix}-apimmain-deploy'
  params: {
    apimName: apimName
    env: env
    location: location
    apiGatewayName: apiGatewayName
  }
}

// Deploy APIM backends (PTU & PAYG)
module apimBackendModule './iac/api/apim-backend.bicep' = {
  name: '${prefix}-apimbackend-deploy'
  params: {
    apimName: apimName
    env: env
    openAIPTUUrl: openAIPTUUrl
    openAIPAYGUrl: openAIPAYGUrl
  }
}

// Deploy APIM subscription
module apimSubscriptionModule './iac/api/apim-subscription.bicep' = {
  name: '${prefix}-apimsub-deploy'
  params: {
    apimName: apimName
    env: env
  }
}

// Deploy APIM utilities (e.g. Redis cache integration)
module apimUtilsModule './iac/api/apim-utils.bicep' = {
  name: '${prefix}-apimutils-deploy'
  params: {
    apimName: apimName
    env: env
    redisConnectionString: 'DefaultEndpointsProtocol=https;AccountName=yourAccount;AccountKey=yourKey'
    redisHostName: '${prefix}-redis'
  }
}

// Deploy API definitions (handler & OpenAI)
module apiPmmModule './iac/api/apipm-api.bicep' = {
  name: '${prefix}-api-pm-deploy'
  params: {
    apimName: apimName
    env: env
    apiGatewayName: apiGatewayName
  }
}

//UTILITY
module redisModule './iac/utils/redis.bicep' = {
  name: '${prefix}-redis-deploy'
  params: {
    location: location
    env: env
    redisName: '${prefix}-redis'
  }
}

// Deploy Azure OpenAI services (PTU & PAYG)
module openaiModule './iac/utils/openai.bicep' = {
  name: '${prefix}-openai-deploy'
  params: {
    location: location
    prefix: prefix
  }
}

// EVENTS
module eventGridModule './iac/events/eventGrid.bicep' = {
  name: '${prefix}-eventgrid-deploy'
  params: {
    location: location
    env: env
  }
}

module serviceBusModule './iac/events/serviceBus.bicep' = {
  name: '${prefix}-sb-deploy'
  params: {
    location: location
    env: env
    sbNamespaceName: sbNamespaceName
  }
}

// FUNCTIONS
module funcHighModule './iac/functions/azureFunctionHighPriority.bicep' = {
  name: '${prefix}-func-high-deploy'
  params: {
    location: location
    env: env
    workerRuntime: workerRuntime
  }
}

module funcLowModule './iac/functions/azureFunctionLowPriority.bicep' = {
  name: '${prefix}-func-low-deploy'
  params: {
    location: location
    env: env
    workerRuntime: workerRuntime
    sbNamespaceName: sbNamespaceName
  }
}

// KNOWLEDGE BASE SERVICES
module blobStorageModule './iac/knowledge_base/blobStorage.bicep' = {
  name: '${prefix}-blob-deploy'
  params: {
    location: location
    env: env
  }
}

module cognitiveSearchModule './iac/knowledge_base/cognitiveSearch.bicep' = {
  name: '${prefix}-search-deploy'
  params: {
    location: location
    env: env
  }
}

module cosmosModule './iac/knowledge_base/cosmosDb.bicep' = {
  name: '${prefix}-cosmos-deploy'
  params: {
    accountName: cosmosAccountName
    env: env
    location: location
    primaryRegion: primaryRegion
    secondaryRegion: secondaryRegion
    defaultConsistencyLevel: defaultConsistencyLevel
    maxStalenessPrefix: maxStalenessPrefix
    maxIntervalInSeconds: maxIntervalInSeconds
    systemManagedFailover: systemManagedFailover
    databaseName: databaseName
    containerName: containerName
    autoscaleMaxThroughput: autoscaleMaxThroughput
  }
}
