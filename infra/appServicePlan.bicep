// App Service Plan Bicep module
param location string
param environment string
param randomSuffix string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'zavastoreplan${environment}${randomSuffix}'
  location: location
  kind: 'linux'
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: true // required for Linux
  }
}

output appServicePlanId string = appServicePlan.id
