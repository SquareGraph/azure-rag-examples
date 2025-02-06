@description('The name of the APIM instance')
param apimName string

@description('The environment to deploy to')
@allowed([
  'dev'
  'test'
  'prod'
])
param env string

@description('The connection string for the Redis cache')
param redisConnectionString string

@description('The host name for the Redis cache')
param redisHostName string

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: '${apimName}-${env}'
}

resource apimCache 'Microsoft.ApiManagement/service/caches@2021-08-01' = {
  parent: apim
  name: 'redisCache-${env}'
  properties: {
    useFromLocation: 'default'
    connectionString: redisConnectionString
    description: redisHostName
  }
}
