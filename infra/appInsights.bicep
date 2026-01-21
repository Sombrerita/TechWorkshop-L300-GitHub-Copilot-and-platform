// Application Insights Bicep module
param location string
param environment string
param randomSuffix string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'zavastoreai${environment}${randomSuffix}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output instrumentationKey string = appInsights.properties.InstrumentationKey
