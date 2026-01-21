// Web App for Containers Bicep module
param location string
param environment string
param appServicePlanId string
@description('The ACR login server, e.g. zavastoreacrdev123.azurecr.io (no protocol, no trailing slash)')
param randomSuffix string
@description('The user-assigned managed identity resourceId to assign to the Web App')
param userAssignedIdentityResourceId string

param linuxFxVersionValue string
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'zavastoreweb${environment}${randomSuffix}'
  location: location
  tags: {
    'azd-service-name': 'src'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityResourceId}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: linuxFxVersionValue
    }
  }
}

output managedIdentityId string = userAssignedIdentityResourceId
output linuxFxVersion string = linuxFxVersionValue
