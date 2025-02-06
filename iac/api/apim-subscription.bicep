@description('The name of the APIM instance')
param apimName string

@description('The environment to deploy to')
@allowed([
  'dev'
  'test'
  'prod'
])
param env string

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: '${apimName}-${env}'
}

resource apimSubscription 'Microsoft.ApiManagement/service/subscriptions@2024-06-01-preview' = {
  parent: apim
  name: '${apimName}-${env}-subscription'
  properties: {
    displayName: '${apimName}-${env}-subscription'
    scope: {
      subscriptionId: subscription().subscriptionId
    }
    state: 'active'
    primaryKey: '${apimName}-${env}-primary-key'
    secondaryKey: '${apimName}-${env}-secondary-key'
  }
}
