@description('Location for the resources')
param location string

@description('Env, prod, test or dev')
param env string

resource eventGridTopic 'Microsoft.EventGrid/topics@2024-12-15-preview' = {
  name: 'evtgrid-${env}'
  location: location
  properties: {}
} 

var eventGridTopicId = eventGridTopic.id

output eventGridTopicId string = eventGridTopicId
