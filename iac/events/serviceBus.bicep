@description('Location for the resources')
param location string

@description('Prefix for the resources, usually environment name')
param env string

@description('Name of the Service Bus namespace')
param sbNamespaceName string

resource sbNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: '${sbNamespaceName}-${env}-sb'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {}
}

resource sbLowPriorityQueue 'Microsoft.ServiceBus/namespaces/queues@2021-11-01' = {
  name: '${sbNamespace.name}-${env}-lowpriority'
  parent: sbNamespace
  properties: {
    lockDuration: 'PT5M'
    maxDeliveryCount: 10
    deadLetteringOnMessageExpiration: true
  }
}

resource sbDeadLetterQueue 'Microsoft.ServiceBus/namespaces/queues@2021-11-01' = {
  name: '${sbNamespace.name}-${env}-deadletter'
  parent: sbNamespace
  properties: {
    lockDuration: 'PT5M'
    maxDeliveryCount: 5
    deadLetteringOnMessageExpiration: false
  }
} 

var sbConnectionString = 'Endpoint=sb://${sbNamespace.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${sbNamespace.listKeys().primaryKey}'
var sbEndpoint = 'sb://${sbNamespace.name}.servicebus.windows.net/'
var sbLowPriorityQueueName = sbLowPriorityQueue.name
var sbDeadLetterQueueName = sbDeadLetterQueue.name

output sbConnectionString string = sbConnectionString
output sbEndpoint string = sbEndpoint
output sbLowPriorityQueueName string = sbLowPriorityQueueName
output sbDeadLetterQueueName string = sbDeadLetterQueueName
