// Microsoft Foundry Bicep module
param location string
param foundrySku string
param environment string
param randomSuffix string

resource foundry 'Microsoft.Foundry/accounts@2023-01-01-preview' = {
  name: 'zavastorefoundry${environment}${randomSuffix}'
  location: location
  sku: {
    name: foundrySku
  }
}

output foundryId string = foundry.id
