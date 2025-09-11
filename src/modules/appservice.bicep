targetScope = 'resourceGroup'

param pName string
param pEnviroment string
param pSku string
param pCapacity int
param pLocation string
param pTags object

var appServicePlanName = '${pEnviroment}-${pName}-appserviceplan'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: pLocation
  sku: {
    name: pSku
    capacity: pCapacity
  }
  tags: pTags
}

output appServicePlanName string = appServicePlanName
output appServicePlanId string = appServicePlan.id
