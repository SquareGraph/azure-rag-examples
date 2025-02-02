@description('Location for the resources')
param location string

@description('Prefix for the resources, usually environment name')
param env string

@description('Name of the Service Bus namespace')
param sbNamespaceName string

resource sbNamespace 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: '${sbNamespaceName}-${env}-sb'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {}
}

resource sbLowPriorityQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' = {
  name: '${sbNamespace.name}-${env}-lowpriority'
  parent: sbNamespace
  properties: {
    lockDuration: 'PT5M'
    maxDeliveryCount: 10
    deadLetteringOnMessageExpiration: true
  }
}

resource sbDeadLetterQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' = {
  name: '${sbNamespace.name}-${env}-deadletter'
  parent: sbNamespace
  properties: {
    lockDuration: 'PT5M'
    maxDeliveryCount: 5
    deadLetteringOnMessageExpiration: false
  }
} 
