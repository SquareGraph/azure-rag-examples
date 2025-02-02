param location string
param prefix string

resource sbNamespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: '${prefix}-sb'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {}
}

resource sbLowPriorityQueue 'Microsoft.ServiceBus/namespaces/queues@2021-06-01-preview' = {
  name: '${sbNamespace.name}/${prefix}-lowpriority'
  properties: {
    lockDuration: 'PT5M'
    maxDeliveryCount: 10
  }
}

resource sbDeadLetterQueue 'Microsoft.ServiceBus/namespaces/queues@2021-06-01-preview' = {
  name: '${sbNamespace.name}/${prefix}-deadletter'
  properties: {
    lockDuration: 'PT5M'
    maxDeliveryCount: 5
  }
} 
