param location string
param prefix string

resource openAIPTU 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: '${prefix}-openai-ptu'
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    apiProperties: {
      throughputMode: 'Provisioned'
      throughput: 1
    }
  }
  tags: {
    priority: '1'
  }
}

resource openAIPAYG 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: '${prefix}-openai-payg'
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    apiProperties: {
      throughputMode: 'Serverless'
    }
  }
  tags: {
    priority: '2'
  }
}


output openAIPTUEndpoint string = openAIPTU.properties.endpoint
output openAIPAYGEndpoint string = openAIPAYG.properties.endpoint 
