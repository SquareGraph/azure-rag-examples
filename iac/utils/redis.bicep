@description('Location for the resources')
param location string

@description('Env, prod, test or dev')
@allowed([
  'prod'
  'test'
  'dev'
])
param env string

@description('Name of the Redis cache')
param redisName string

resource redis 'Microsoft.Cache/redis@2024-11-01' = {
  name: '${redisName}-${env}'
  location: location
  properties: {

    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 0
    }
  }
} 

var redisConnectionString = '${redis.properties.hostName}:${redis.properties.sslPort}'
var redisHostName = redis.properties.hostName
var redisSslPort = redis.properties.sslPort

output redisConnectionString string = redisConnectionString
output redisHostName string = redisHostName
output redisSslPort int = redisSslPort
