// Role Assignment Bicep module
param principalId string
param acrId string

resource acrPullRole 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acrId, principalId, 'acrpull')
  properties: {
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
