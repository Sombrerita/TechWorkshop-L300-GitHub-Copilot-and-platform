// Azure Container Registry Bicep module
param location string
param acrSku string
param environment string
param randomSuffix string

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: 'zavastoreacr${environment}${randomSuffix}'
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
}

output acrId string = acr.id
output loginServer string = acr.properties.loginServer
