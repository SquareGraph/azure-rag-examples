param location string
param prefix string

resource eventGridTopic 'Microsoft.EventGrid/topics@2021-12-01' = {
  name: '${prefix}-evtgrid'
  location: location
  properties: {}
} 
