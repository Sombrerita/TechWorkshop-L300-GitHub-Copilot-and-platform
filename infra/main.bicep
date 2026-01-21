// Main Bicep template for ZavaStorefront infrastructure
param environment string = 'dev'
@description('If true, only deploy ACR. If false, deploy all resources.')
param deployAcrOnly bool = false
param location string = resourceGroup().location
param acrSku string = 'Basic'
param randomSuffix string = uniqueString(resourceGroup().id)

// Always deploy ACR
module acr 'acr.bicep' = {
  name: 'acrModule'
  params: {
    location: location
    acrSku: acrSku
    environment: environment
    randomSuffix: randomSuffix
  }
}

// Deploy user-assigned managed identity (UMI) for the Web App
module webAppIdentity 'webAppIdentity.bicep' = if (!deployAcrOnly) {
  name: 'webAppIdentityModule'
  params: {
    location: location
    environment: environment
    randomSuffix: randomSuffix
  }
}

module roleAssignment 'roleAssignment.bicep' = if (!deployAcrOnly) {
  name: 'roleAssignmentModule'
  params: {
    principalId: webAppIdentity.outputs.identityPrincipalId
    acrId: acr.outputs.acrId
  }
}

module appServicePlan 'appServicePlan.bicep' = if (!deployAcrOnly) {
  name: 'appServicePlanModule'
  params: {
    location: location
    environment: environment
    randomSuffix: randomSuffix
  }
}

var cleanAcrLoginServer = acr.outputs.loginServer
var imageName = 'zavastorefront:latest'
var linuxFxVersionValue = 'DOCKER|${cleanAcrLoginServer}/${imageName}'

module webApp 'webApp.bicep' = if (!deployAcrOnly) {
  name: 'webAppModule'
  dependsOn: [
    acr
    webAppIdentity
    roleAssignment
  ]
  params: {
    location: location
    environment: environment
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    linuxFxVersionValue: linuxFxVersionValue
    randomSuffix: randomSuffix
    userAssignedIdentityResourceId: webAppIdentity.outputs.identityResourceId
  }
}

module appInsights 'appInsights.bicep' = if (!deployAcrOnly) {
  name: 'appInsightsModule'
  params: {
    location: location
    environment: environment
    randomSuffix: randomSuffix
  }
}

// module foundry 'foundry.bicep' = {
//   name: 'foundryModule'
//   params: {
//     location: location
//     foundrySku: foundrySku
//     environment: environment
//     randomSuffix: randomSuffix
//   }
// }

// Output the registry endpoint for azd
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = acr.outputs.loginServer
