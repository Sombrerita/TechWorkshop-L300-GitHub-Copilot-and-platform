// User-assigned managed identity for Web App
param location string
param environment string
param randomSuffix string

resource webAppIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'zavawebappid${environment}${randomSuffix}'
  location: location
}

output identityPrincipalId string = webAppIdentity.properties.principalId
output identityResourceId string = webAppIdentity.id
