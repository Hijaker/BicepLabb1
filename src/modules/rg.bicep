targetScope = 'subscription'

param pName string
param pEnviroment string
param pLocation string
param pTags object


resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: pName
  location: pLocation
  tags: pTags
}

output resourceGroupName string = pName
