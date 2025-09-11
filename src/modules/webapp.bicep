targetScope = 'resourceGroup'

param pName string
param pLocation string
param pServerFarmId string
param pEnviroment string
param pHttpsOnly bool
param pTags object
param utc string = utcNow() // Används för att garantera unikt namn, då vissa resources (t.ex. KeyVault) lever kvar i upp till 30 dagar efter deletion

var websiteName = '${pEnviroment}-${pName}-appservice-${uniqueString(resourceGroup().id, utc)}'

resource website 'Microsoft.Web/sites@2024-11-01' = {
  name: websiteName
  location: pLocation
  properties: {
    serverFarmId: pServerFarmId
    httpsOnly: pHttpsOnly
  }
  tags: pTags
}

output websiteName string = websiteName
